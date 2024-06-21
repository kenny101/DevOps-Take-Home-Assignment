import os
import shutil
from datetime import datetime, timedelta
import argparse

def backup_database(db_file, backup_dir):
    if not os.path.exists(backup_dir):
        os.makedirs(backup_dir)
    
    backup_file = os.path.join(backup_dir, f'{os.path.basename(db_file)}_{datetime.now().strftime("%Y%m%d_%H%M%S")}.bak')
    shutil.copy(db_file, backup_file)
    print(f'Backup of {db_file} created at {backup_file}')


def clean_old_backups(backup_dir, keep_days):
    now = datetime.now()
    for filename in os.listdir(backup_dir):
        backup_path = os.path.join(backup_dir, filename)
        modify_time = datetime.fromtimestamp(os.path.getmtime(backup_path))
        if now - modify_time > timedelta(days=keep_days):
            os.remove(backup_path)
            print(f'Removed old backup: {backup_path}')


def main(database_dir, backup_dir, keep_backup_days):
    data_db_file = os.path.join(database_dir, 'data.db')
    logs_db_file = os.path.join(database_dir, 'logs.db')

    # backup data and logs db
    backup_database(data_db_file, backup_dir)
    backup_database(logs_db_file, backup_dir)

    # remove any old backups
    clean_old_backups(backup_dir, keep_backup_days)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='backup database files by directory and remove older backups')
    parser.add_argument('--database-dir', type=str, default='databases', help='path to databases directory')
    parser.add_argument('--backup-dir', type=str, default='backups', help='path to backups directory')
    parser.add_argument('--keep-backup-days', type=int, default=7, help='number of days to keep backups, expired backups will be deleted')

    args = parser.parse_args()

    main(args.database_dir, args.backup_dir, args.keep_backup_days)
