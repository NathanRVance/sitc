# SITC
## Server In The Cloud

SITC is a set of scripts that installs a computational chemistry webserver to a linux machine. Its intended application is to configure cloud instances, though it can be used as a general installer for WebMO and/or various computational chemistry engines. The technologies that SITC supports are:
  * Operating systems: Ubuntu, Debian, CentOS
  * Computational chemistry engines: Quantum Espresso, GAMESS, Gaussian, MOPAC, NWChem, ORCA, PSI4, Tinker
  * Frontend: WebMO
  * Webserver: Apache2

## Quickstart

On the machine you wish to configure, execute the `install` script. You may wish to run `install --help` to view an exhaustive list of options. Common options include:
  * `--engines="ENGINES"` where ENGINES is a comma separated list of computational chemistry engines to install.
  * `--skip-engines` to perform a WebMO only installation. This is equivalent to specifying `--engines=""`.
  * `--skip-webmo` to install engines only.
  * `--upgrade-webmo` to upgrade WebMO.

When scripting installations, specify all desired options on the command line along with `-yy` to skip prompts. Alternatively, modify `install.conf` to include all desired options and execute `install` without options. As distributed, install.conf sets WebMO and Mopac7 to be installed, and this behavior is overridden by command line arguments. See `install.conf` for further instructions.
