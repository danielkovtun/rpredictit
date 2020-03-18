## Resubmission
This is a resubmission. In this version I have:

* Added error handling to data structure-dependent functions that require valid HTTP responses.
* Modified vignette to prevent evaluating all of the examples, as the 'PredictIt' API rate limits requests. 

## Test environments
* local Windows 10 install x86_64-w64-mingw32 (64-bit), R 3.6.2 and R-devel
* Windows Server 2008 R2 SP1 (on rhub), R-devel, 32/64 bit
* Ubuntu 18.04, R 3.6.1
* Ubuntu 16.04.6 LTS (on travis-ci), R 3.6.2
* Fedora Linux (on rhub), R-devel, clang, gfortran
 
## R CMD check results
There were no ERRORs, WARNINGs, or NOTEs.

## Previous cran-comments

## Resubmission
This is a resubmission. In this version I have:

* Changed warning and informational messages to use `warning()` and `message()` instead of `print()` and `cat()`
* Removed redundant 'R' from the package title
* Modified the package description to not start with a repetition of the title. 
* Modified title and description to use proper quoting for API names. ('PredictIt API' --> 'PredictIt' API)
* Changed all occurences of `T` and `F` to `TRUE` and `FALSE`, respectively.
* Added `\value` to all `.Rd` files to explain function results in the documentation.
* Wrapped `roxygen` comment blocks so that they are less than 80 characters wide.
* Included links to function documentation from other packages in `.Rd` files.

## Test environments
* local Windows 10 install x86_64-w64-mingw32 (64-bit), R 3.6.1 and R-devel
* Windows Server 2008 R2 SP1 (on rhub), R-devel, 32/64 bit
* Ubuntu 18.04, R 3.6.1
* Ubuntu 16.04.6 LTS (on travis-ci), R 3.6.2
* Fedora Linux (on rhub), R-devel, clang, gfortran
 
## R CMD check results
There were no ERRORs, or WARNINGs.

There was 1 NOTE:
* Maintainer: ‘Daniel Kovtun <quantumfusetrader@gmail.com>’
* New submission

## Resubmission
This is a resubmission. In this version I have:

* Changed the invalid URL in the DESCRIPTION and README.md files to one that can pass CRAN URL checks.
* The 'PredictIt' API does not allow 'HEAD' requests, and therefore returns a 405 status value when using `curl -I -L` on the command line.

## Test environments
* local Windows 10 install x86_64-w64-mingw32 (64-bit), R 3.6.1 and R-devel
* Windows Server 2008 R2 SP1 (on rhub), R-devel, 32/64 bit
* Ubuntu 18.04, R 3.6.1
* Ubuntu 16.04.6 LTS (on travis-ci), R 3.6.2
* Fedora Linux (on rhub), R-devel, clang, gfortran
 
## R CMD check results
There were no ERRORs, or WARNINGs.

There was 1 NOTE:
* Maintainer: ‘Daniel Kovtun <quantumfusetrader@gmail.com>’
* New submission

