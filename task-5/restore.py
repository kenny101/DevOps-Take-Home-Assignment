import os
import shutil
import argparse

def restore_database(backup_file, db_file):
    shutil.copy(backup_file, db_file)
    print(f'Restored {db_file} from {backup_file}')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='restore database from a backup file')
    parser.add_argument('backup_file', type=str, help='path to the backup file to restore from')
    parser.add_argument('db_file', type=str, help='path to the sqlite database file to restore')

    args = parser.parse_args()

    # checking if the backup file exists
    if not os.path.exists(args.backup_file):
        print(f'Error: Backup file {args.backup_file} does not exist.')
        exit(1)

    # try to respose db
    try:
        restore_database(args.backup_file, args.db_file)
    except Exception as e:
        print(f'Error occurred during restoration: {str(e)}')
        exit(1)
