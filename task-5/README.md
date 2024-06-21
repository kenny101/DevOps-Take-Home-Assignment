# Task 5 Details

This task contains two sqlite databases in the  `database` directory, `data.db` and `logs.db`.  The scripts `backup.py` and `restore.py` are used to backup and restore the databases.

## Creating Backups

```bash
python3 backup.py --database-dir ./databases --backup-dir ./backups --keep-backup-days 1
```

`--keep-backup-days` specifies the max number of days old the backups should be. For this example, any backup files that are older than 1 day are deleted.

Backup timestamps are written onto the filenames and are used to conditionally remove older backups depending on the `keep-backup-days` parameter

## Restoring Backups

```bash
python3 restore.py --backup_file ./backups/data.db_20240620_181935.bak ./databases/data.db
```

This is a simplier implementation of backing up and restoring sqlite databases. For more comprehensive database backups using database replication [Marmot](https://github.com/maxpert/marmot) is a solution I would have used.

## Creating a Cron Job for further automation (Optional)

If we want to automate this process even more, a cron job can be scheduled on a linux system so that the script runs for example every day at a certain time. The cron job entry bellow can be added so that the backup script is ran everyday at 12am and any backups older than 3 days will be removed.

```bash
0 0 * * * python3 backup.py --database-dir /path/to/databases --backup-dir /path/to/backups --keep-backup-days 3
```
