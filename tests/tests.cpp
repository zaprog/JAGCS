// Qt
#include <QCoreApplication>
#include <QFile>

// Internal
#include "db_manager.h"

// Tests
#include "data_base_test.h"
#include "communication_test.h"

int main(int argc, char* argv[])
{
    QCoreApplication app(argc, argv);

    {
        QFile file("test_db");
        if (file.exists()) file.remove();
    }

    data_source::DbManager manager;

    manager.open("test_db");
    bool created = manager.create();

    if (!created)
    {
        qDebug() << "Error while creating DB!";
        return 0;
    }

    DataBaseTest dbTest;
    QTest::qExec(&dbTest);

    CommunicationTest comTest;
    QTest::qExec(&comTest);

    return 0;
}
