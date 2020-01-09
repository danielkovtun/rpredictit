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

