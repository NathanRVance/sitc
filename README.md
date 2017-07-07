# SITC
## Server In The Cloud

SITC is a set of scripts that installs a computational chemistry webserver to a linux machine. Its intended application is to configure cloud instances, though it can be used as a general installer for WebMO and/or various computational chemistry engines. The technologies that SITC supports are:
  * OS's: Ubuntu, Debian, CentOS
  * Computational software: Quantum Espresso, GAMESS, Gaussian, MOPAC, NWChem, ORCA, PSI4, Tinker
  * Front end: WebMO
  * Webserver: Apache2

## Quickstart

On the machine you wish to configure (cloud or otherwise), execute the `install` script.  
Common options include:
  * `--help` provides an exhaustive list of options.
  * `--engines="ENGINES"` where ENGINES is a comma separated list of computational chemistry engines to install.
  * `--skip-engines` to perform a WebMO only installation. This is equivalent to specifying `--engines=""`.
  * `--skip-webmo` to install engines only.
  * `--upgrade-webmo` to upgrade WebMO.
  * Default installs WebMO and Mopac7.

When scripting installations, specify all desired options on the command line along with `-yy` to skip prompts. Alternatively, modify `install.conf` to include all desired options and execute `install` without options. See `install.conf` for further instructions.
