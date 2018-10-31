HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${HERE}/common.bash"


function get_package_name() {
    name="$1"
    echo "dbt_${name}-$(get_version)-py2.py3-none-any.whl"
}


function package_core() {
    mkdir -p "${DIST_DIR}"
    result="${DBT_CORE_ROOT}/dist/dbt_core-$(get_version)-py2.py3-none-any.whl"
    cd "${DBT_CORE_ROOT}"
    python setup.py bdist_wheel --universal
    cd ..
    mv "${result}" "${DIST_DIR}"
}

function package_plugin() {
    mkdir -p ${DIST_DIR}
    plugin_name="$1"
    shift
    plugin_root="${BUILD_ROOT}/plugins/${plugin_name}"
    result="${plugin_root}/dist/dbt_${plugin_name}-$(get_version)-py2.py3-none-any.whl"
    cd "${plugin_root}"
    python setup.py bdist_wheel --universal
    cd ..
    mv "${result}" "${DIST_DIR}"
}

function package_all() {
    package_core
    package_plugin postgres
    package_plugin redshift
    package_plugin snowflake
    package_plugin bigquery
}

if [[ -z "$1" ]] || [[ "$1" == "all" ]]; then
    package_all
elif [[ "$1" == "core" ]]; then
    package_core
else
    package_plugin "$1"
fi
