BUILD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
DBT_CORE_ROOT=${BUILD_ROOT}/core
DIST_DIR=${BUILD_ROOT}/dist


function get_version() {
    grep -F '__version__ =' ${DBT_CORE_ROOT}/dbt/version.py | cut -d '=' -f '2-' | tr -d "'[[:space:]]"
}
