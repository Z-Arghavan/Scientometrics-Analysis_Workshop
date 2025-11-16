# Installation Guide for R and RStudio  
This repository contains the instructions used during the workshop for *bibliometric and scientometric analysis*.  
Follow the steps below to install R and Rstudio tools correctly on your computer. Then, we can install the _Bibliometrix_ package and start the analysis. 

---

## 1. About R and RStudio

### What is R?
R is a programming language used for statistics, data analysis, and scientific computing.  
It contains all core functions needed for processing and analysing metadata.

### What is RStudio?
RStudio is an integrated development environment that provides a user friendly interface for R.  
It includes panels for code, plots, files, and the R console.

### Relationship between R and RStudio  
- R provides the language.  
- RStudio provides the interface.  
- R must be installed before RStudio, because RStudio depends on it.

---

## 2. How to install R

1. Open the official R download page:  
   https://cran.r-project.org  
2. Chosse your closest location.
3. Choose your operating system and download the installer file.  
4. Run the installer (Accept the default settings unless you have a specific reason to change them).  

---

## 3. How to install RStudio

1. Go to the RStudio download page:  
   https://posit.co/download/rstudio-desktop  
2. Download the free RStudio Desktop version for your operating system.  
3. Run the installer and complete the installation based on your desired settings.  
4. Open RStudio. It will automatically detect your R installation (otherwise, you will get an error about compatibility).  
Note that R and Rstudio environmets look visually different. In this tutorual, we use the R language in Rstudio environment. 

## 5. Install the Bibliometrix Package

_Bibliometrix_ package is required for scientometric and bibliometric analysis in Rstudio.

To read more about it, got to https://www.bibliometrix.org/home/  
Follow the steps below to install it:

1. Open **RStudio**.
2. In the Console panel, type the command below and press Enter:
   ```r
   install.packages("bibliometrix")
After installation completes, load the package with:

r
Copy code
library(bibliometrix)
To confirm the package is working, check the help page:


?bibliometrix
You are now ready to import metadata files and run scientometric analysis.

