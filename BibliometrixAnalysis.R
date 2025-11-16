#......Load "bibliometrix":
library('bibliometrix')

myfile <- ("https://bibliometrix.org/datasets/joi.txt")

# Converting the loaded files into a R bibliographic dataframe. Keep in mind that for different platforms, e.g., Scopus, Web of Science (WoS), PubMed, Google Scholar and so on, you need to chat the dbsource and format!
# There is an option to merge them (after removing the duplicates). Merging is not possible in the Biblioshiny.
M <- convert2df(file=myfile, dbsource="wos",format="plaintext")
#.....DATA LOADING AND CONVERTING
file <- ("C:/XXX/yourrepoXXX/testFinal.bib")

#wosCollection <- convert2df(file1, dbsource = "wos", format = "bibtex")
M <- convert2df(file, dbsource = "scopus", format = "bibtex")

# Extracts and separates metadata fields into a usable form (these are extra, but helpful - yet, notall downloaded record from WoS or Scopus will have them. So, if you run into errors, check if the merge of WoS and Scopus records have issues because of these below)
# AU_CO: author country
# CR_AU: cited reference authors
# CR_SO: cited source journals
# ID_TM: thematic identifier keywords
M <- metaTagExtraction(M, Field = "AU_CO", sep = ";")
M <- metaTagExtraction(M, Field = "CR_AU", sep = ";")
M <- metaTagExtraction(M, Field = "CR_SO", sep = ";")
M <- metaTagExtraction(M, Field = "AU_CO", sep = ";")
M <- metaTagExtraction(M, Field = "AU1_CO", sep = ";")
M <- metaTagExtraction(M, Field = "ID_TM", sep = ";")

#.....START OF THE BIBLIOMETRIC ANALYSIS
# - Performs general bibliometric statistics such as: most productive authors, journals, countries, citations, yearly growth and so on
# - Creates a summary table showing the top elements (k = 10)
results <- biblioAnalysis(M, sep = ";")
S <- summary(object = results, k = 10, pause = FALSE)
plot(x = results, k = 10, pause = FALSE)


# Builds a **country collaboration** network based on co authored papers
NetMatrix <- biblioNetwork(M, analysis = "collaboration", network = "countries", sep = ";")
# Plot the network
net=networkPlot(NetMatrix, n = dim(NetMatrix)[1], Title = "Country Collaboration", type = "circle",
                size=TRUE, remove.multiple=FALSE,labelsize=0.8)


### Co-Citation Network
# Co citation analysis identifies documents that are cited together
# Documents often co cited tend to belong to the same intellectual tradition or school of thought
NetMatrix <- biblioNetwork(M, analysis = "co-citation", network = "references", sep = ";")
# Plot the network
net=networkPlot(NetMatrix, n = 30, Title = "Co-Citation Network", type = "fruchterman", size=T,
                remove.multiple=FALSE, labelsize=0.7,edgesize = 5)



### Keyword co-occurrences
# Co occurrence analysis shows which keywords appear together in the same papers
# This part shows the main themes and topics that structure the research field 
NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "keywords", sep = ";")
# Plot the network
net=networkPlot(NetMatrix, normalize="association", weighted=T, n = 30, Title = "Keyword Cooccurrences",
                type = "fruchterman", size=T,edgesize = 5,labelsize=0.7)


#CO-WORD ANALYSIS: THE CONCEPTUAL STRUCTURE OF A FIELD
# Co-word analysis explores patterns of keywords that co occurr. This helps to canvass the conceptual structure of a fiels. This code identifies how ideas, topics, and concepts are linked in the scientific domain of intrest
# MCA stands for Multiple Correspondence Analysis, used for dimensional reduction - there are other options avaiable here, please refer to the reference manual and chose the one that suits your analysis
# Conceptual Structure using keywords (method="MCA")
CS <- conceptualStructure(M,field="DE", method="MCA", minDegree=10,clust=3, k.max=8, stemming=
                            FALSE, labelsize=10, documents=20)



#HISTORICAL DIRECT CITATION NETWORK
# Historical citation network shows how influential papers cite each other over time and chronologically. This graph can be very handy but sometimes difficult to produce, depending also if the source is from WoS os Scopus (or both).
# It helps to trace the evolution of key papers, ideas, methods or milestones in the field
histResults <- histNetwork(M, min.citations = 1, sep = ";", network = TRUE, verbose = TRUE)
net <- histPlot(histResults, n=20, labelsize = 5, size = 5, verbose = TRUE)
# Plot a historical co-citation network

histResults <- histNetwork(M, sep = ";")
options(width = 130)
net <- histPlot(histResults, n=20, size = 5, labelsize = 4)
NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "keywords", sep = ";")
net=networkPlot(NetMatrix, normalize="association", n = 50, Title = "Keyword Co-occurrences", type = "fruchterman", size.cex=TRUE, size=20, remove.multiple=F, edgesize = 10, labelsize=5,label.cex=TRUE,label.n=30,edges.min=2)


options(width = 100)
S <- summary(object = results, k = 10, pause = FALSE)
NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "author_keywords", sep = ";")
S <- normalizeSimilarity(NetMatrix, type = "association")
net <- networkPlot(S, n = 200, Title = "co-occurrence network", type = "fruchterman", 
                   labelsize = 0.7, halo = FALSE, cluster = "walktrap",
                   remove.isolates = FALSE, remove.multiple = FALSE, noloops = TRUE, weighted = TRUE)

# Plot Thematic Map
# A thematic map shows the main themes of the field based on keyword clusters. Themes are classified as motor themes, niche themes, emerging themes, or basic themes
NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "author_keywords", sep = ";")
S <- normalizeSimilarity(NetMatrix, type = "association")
net <- networkPlot(S, n = 200, Title = "co-occurrence network",type="fruchterman",
                   labelsize = 0.7, halo = T, cluster = "walktrap",remove.isolates=FALSE,
                   remove.multiple=FALSE, noloops=TRUE, weighted=TRUE)
res <- thematicMap(M, field = "DE", n = 250, minfreq = 4, size = 0.5, repel = TRUE)
plot(res$map)

Map=thematicMap(M, field = "ID", n = 250, minfreq = 4,
                stemming = FALSE, size = 0.7, n.labels=5, repel = TRUE)
plot(Map$map)


#REGEXExamples
M$DE <- gsub(pattern="BUILDING INFORMATION MODELLING", replacement="BIM", M$DE)
M$DE <- gsub(pattern="LIFE CYCLE ASSESSMENT", replacement="LCA", M$DE)
M$DE <- gsub(pattern="DFD", replacement="DESIGN FOR DECONSTRUCTION", M$DE)
M$DE <- gsub(pattern="DESIGN FOR DISASSEMBLY", replacement="DESIGN FOR DECONSTRUCTION", M$DE)

M$DE <- lapply(M$DE, gsub, pattern='&', replacement='')
M$DE <- gsub(pattern = "\\\\",replacement = "", M$DE)
M$DE <- gsub("\\s*\\([^\\)]+\\)","",as.character(M$DE))

suppressWarnings(
  CS <- conceptualStructure(M, method="MCA", field="DE", minDegree=15, clust=5, stemming=FALSE, labelsize=15,documents=20)
)
