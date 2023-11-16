# PyRdev
This is template repository to make Python and R development envrironment on docker. Using this template, the same development environment can be created across development teams. It also helps ensure reproducibility of analysis and other results.  
'PyRdev' can be used in VSCode.

## Quick start
```
git clone https://github.com/matsurix28/PyR.git; bash ./PyRdev/.build/setup.sh
```
If you are using rootless mode, restart the shell to reflect the addition of the group.

## Usage
### For administrator
1. **Clone PyRdev and set up development environment**
Set up Project environment.
Run `git clone https://github.com/matsurix28/PyRdev.git; bash ./PyRdev/.build/setup.sh`
2. **Attach container**
    1. **Using VSCode**  
       Open Project Folder. And select "Reopen in Container".
    2. **Using Terminal**  
   `cd PROJECT_DIR`  
`docker compose up -d`  
`docker attach CONTAINER`
3. **Edit Python and R scripts**
4. **Record packages information**  
   Run `save` command to save apt and R packages. For python, you can use `pipenv install PACKAGE`.
5. **(Rootless user only: Restart Shell)**  
If you are using this container for the first time in rootless mode, you will need to restart the shell to reflect `groupadd`.   
6. **Push repository to GitHub**
### For coworkers and users
1. **Clone Project and run startup script**  
Set UID and GID to container, and install required Python and R packages.
2. **Attach container**
    1. **Using VSCode**  
       Open Project Folder. And select "Reopen in Container".
    2. **Using Terminal**  
    `cd PROJECT_DIR`  
`docker compose up -d`  
`docker attach CONTAINER`
3. **Edit Python and R scripts**
4. **Record packages information**  
   Run `save` command to save apt and R packages. For python, you can use `pipenv install PACKAGE`.

## First Set up
Please run `setup.sh` before using this template.

- **Add dockr container group (rootless user only)**  
When using Docker-rootless mode, workspace owner is different from host user (uid in container = host uid + subuid). So create docker-rootless group and add user to edit files on host machine.

- **Python and R version**  
Enter Python and R version used in your project.

- **Project Name**  
Project name is used for docker container and host directory names.

- **Set User ID and Group ID in docker container**  
Set User and group ID in docker container to the same as host machine.

- **Create renv volume**  
This renv volume is used global cache directory of R packages.

- **Initialize renv**  
Start using renv in the project. Create renv directory and .Rprofile.  

- **Initialize pipenv**  
Start using pipenv in the project. Create .venv directory and Pipfile.
