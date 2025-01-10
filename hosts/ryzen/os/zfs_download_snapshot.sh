HOST=gitlab
DATASET=(
    "gitlab/share"
    "gitlab/var/lib/docker-compose"
    "gitlab/var/lib/docker/volumes"
    "gitlab/var/lib/postgresql"
)

new=$(date -d "last sunday" +%y%m%d)
for ds in "${DATASET[@]}"; do
    old=$(zfs list -H -t snapshot "ryzen/$ds" | awk '{print $1}' | awk -F '@auto-' '{print $2}')
    echo "$ds: backup from $old to $new"
    ssh "$HOST" sudo zfs send -i "$ds@auto-$old" "$ds@auto-$new" | zfs recv "ryzen/$ds"
    zfs destroy "ryzen/$ds@auto-$old"
done
