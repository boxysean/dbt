HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${HERE}/common.bash"

devpi use http://127.0.0.1:3141
devpi login root --password="password"
devpi use public
devpi upload --from-dir ${BUILD_ROOT}/dist

packages=( core postgres redshift snowflake bigquery )
version="$(get_version)"
for i in ${packages[@]}; do
	devpi push "dbt-${packages[$i]}==${version}" root/public
done
