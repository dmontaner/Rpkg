#! /usr/bin/Rscript --vanilla

## init.r
## 2017-02-23 david.montaner@gmail.com
## create skeleton for a new R package

rm (list = ls ())
R.version.string ##"R version 3.3.0 (2016-05-03)"
library (devtools); packageDescription ("devtools", fields = "Version") #"1.11.1"
##help (package = devtools)

## library (roxygen2);  packageDescription ("roxygen2",  fields = "Version") #"4.1.1"
## library (rmarkdown); packageDescription ("rmarkdown", fields = "Version") #"0.7"
## library (knitr);     packageDescription ("knitr",     fields = "Version") #"1.10.5"

################################################################################

PKG = "nuevo"            ## Name of the package here
BIOCONDUCTOR <- FALSE    ## Is a Bioconductor library?

### INITIALIZE the folder structure for the library
sg <- c ("knitr", "rmarkdown", "testthat")
bv <- NULL
if (BIOCONDUCTOR) {
    sg <- c (sg, "BiocStyle")
    bv <- "StatisticalMethod"
}

descripcion <- list (
    Package = PKG,
    Depends = "R (>= 3.0.0)",
    "Authors@R" = 'person ("David", "Montaner", email = "david.montaner@gmail.com", role = c ("aut", "cre"))',
    ##"Authors@R" = 'c (person ("David", "Montaner", email = "david.montaner@gmail.com", role = c ("aut", "cre")),
    ##  person ("Someone", "Else", email = "se@gmail.com", role = c ("aut")))',
    License = "GPL-2",
    Date = Sys.Date (),
    URL = paste0 ("http://www.dmontaner.com/, https://github.com/dmontaner/", PKG),
    BugReports = paste0 ("https://github.com/dmontaner/", PKG, "/issues"),
    VignetteBuilder = "knitr",
    Suggests = sg,
    biocViews = bv)

create ("pkg", rstudio = FALSE, description = descripcion)



### README
## use_readme_rmd (pkg = "pkg")


### NEWS
use_news_md (pkg = "pkg")


### TESTS
## This will create ‘tests/testthat.R’, ‘tests/testthat/’
use_testthat (pkg = "pkg")

test.lines <- 
'##tests.r
##2015-10-03 dmontaner@gmail.com
##testing getPages

context ("Testing function getPages")'

writeLines (test.lines, con = file.path ("pkg", "tests", "testthat", "tests.r"))


### TRAVIS
## use_travis (pkg = "pkg") ## cannot be tuned

## language: r
## r: bioc-release
## cache: packages
## before_install:
##   - cd pkg

travis.lines <-
'language: r
cache: packages
before_install:
  - cd pkg'

if (BIOCONDUCTOR) {
    travis.lines <- c (travis.lines, "r: bioc-release")
}

writeLines (travis.lines, con = ".travis.yml")


### VIGNETTES
## Adds needed packages to ‘DESCRIPTION’, and creates draft vignette
## in ‘vignettes/’. It adds ‘inst/doc’ to ‘.gitignore’ so you don't
## accidentally check in the built vignettes.
nombre <- paste0 (PKG, "_intro")
use_vignette (name = nombre, pkg = "pkg")
unlink (file.path ("pkg", ".gitignore"))  ## I do not want the .gitignore

## Bioconductor style vignettes (comment if not required)

if (BIOCONDUCTOR) {

    .file <- file.path ("pkg", "vignettes", paste0 (nombre, ".Rmd"))
    .li <- readLines (.file)
    ## html
    .li <- sub ("output: rmarkdown::html_vignette", "output:\n  BiocStyle::html_document:\n    toc: yes\n    fig_width: 5\n    fig_height: 5", .li)  ## keep all spaces !!!
    ## pdf
    ##.li <- sub ("output: rmarkdown::html_vignette", "output:\n  BiocStyle::pdf_document:\n    toc: yes\n    fig_width: 4\n    fig_height: 4.5", .li)
    ##
    ## not sure if this is still needed
    ## see http://master.bioconductot.org/packages/release/bioc/vignettes/BiocStyle/inst/doc/HtmlStyle.html
    ##.li[which (.li == "---")[2]] <- "---\n\n```{r style, echo = FALSE, results = 'asis'}\nBiocStyle::markdown()\n```"
    ##
    writeLines (.li, con = .file)
}   

##devtools:::add_desc_package (pkg = "pkg", "Suggests", "BiocStyle")


###EXIT
warnings ()
sessionInfo ()
q ("no")
