#! /usr/bin/bash

PROJDIR="/c/Development/cloud-iac-development/github-feature-iac/"

remove_project_files() {
    removal=("config" "scripts" "templates" "cf-pipeline" ".gitignore" "assetinfo.json" "cloud-iac.log")
    for i in ${removal[@]};
    do
        if [ -d "$i" ]; then
            echo "Removing directory '$i'"
            rm -rf $i
        elif [ -e "$i" ]; then
            echo "Removing file '$i'"
            rm "$i"
        fi
    done
}

deploy_pipeline() {
    if [ "$2" == "exec" ]; then
        echo "Deploying pipeline.."
        cloud-iac deploy-pipeline
    fi
}

cd "$PROJDIR"

case "$1" in
"iac")
    cd /c/Development/git.sami.int.thomsonreuters.com/cloud-iac
    pip uninstall -y cloud-iac
    python setup.py sdist bdist_wheel
    pip install -e .
    # pip install dist/cloud_iac-1.3.1-py3-none-any.whl
    cd "$PROJDIR"
    # deploy_pipeline
    ;;
"comm")
    cd /c/Development/git.sami.int.thomsonreuters.com/cloud-iac-common
    pip uninstall -y cloud-iac-common
    python setup.py sdist bdist_wheel
    pip install -e .
    # pip install dist/cloud_iac_common-1.3.1-py2.py3-none-any.whl
    cd "$PROJDIR"
    # deploy_pipeline
    ;;
"one")
    cd /c/Development/github.com/nuvola_cloud-iac
    pip uninstall -y cloud-iac
    python setup.py sdist bdist_wheel
    pip install -e .
    # pip install dist/cloud_iac-1.3.1-py3-none-any.whl
    cd "$PROJDIR"
    # deploy_pipeline
    ;;
"clean")
    remove_project_files

    cloud-iac init --create-project
    cloud-iac deploy-pipeline --dryrun

    ;;
"rename")
    if [ -e "project_seed.yaml" ]; then
        mv project_seed.yaml project_seed_temp.yaml
    elif [ -e "project_seed_temp.yaml" ]; then
        mv project_seed_temp.yaml project_seed.yaml
    fi
    ;;
*)
    echo "
    usage: ./rebuild.sh [iac | comm | clean | rename ] [exec]

    Invalid command entered."
    ;;
esac
