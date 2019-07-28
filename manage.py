from flask_migrate import Migrate, MigrateCommand

from app import app, db
from flask_script import Manager

manager = Manager(app)

migrate = Migrate(app, db)

manager.add_command('db', MigrateCommand)

if __name__ == '__main__':

    app.run()
    # manager.run()