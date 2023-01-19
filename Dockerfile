# The build-stage image:
FROM continuumio/miniconda3 AS build

# Install the package as normal:
COPY environment.yml .
RUN conda env create -f environment.yml

# Install tximport 1.27.1 from github 
# (as per current github head, commit: https://github.com/mikelove/tximport/commit/66bc7bb06fcafad376194ed065b8ce438080e505 on 1/11/2023)
# Remove devtools after as only used to build env
RUN conda run -n this_env Rscript -e "devtools::install_github('mikelove/tximport')" && conda uninstall -n this_env r-devtools

# When image is run, run the code with the environment
# activated:
COPY entrypoint.sh /.entry/
ENTRYPOINT ["/.entry/entrypoint.sh"]