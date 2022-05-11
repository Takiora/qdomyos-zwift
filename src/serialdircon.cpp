#include "serialdircon.h"

#include <QDebug>
#include <QSerialPort>
#include <QTime>

serialDircon::serialDircon(QObject *parent) : QThread(parent) {}

serialDircon::~serialDircon() {
    m_mutex.lock();
    m_quit = true;
    m_mutex.unlock();
    wait();
}

void serialDircon::open(const QString &portName, int waitTimeout) {
    const QMutexLocker locker(&m_mutex);
    m_portName = portName;
    m_waitTimeout = waitTimeout;
    if (!isRunning())
        start();
}

void serialDircon::run() {
    bool currentPortNameChanged = false;

    m_mutex.lock();

    QString currentPortName;
    if (currentPortName != m_portName) {
        currentPortName = m_portName;
        currentPortNameChanged = true;
    }

    int currentWaitTimeout = m_waitTimeout;
    m_mutex.unlock();

    QSerialPort serial;

    while (!m_quit) {
        if (currentPortNameChanged) {
            serial.close();
            serial.setPortName(currentPortName);
            serial.setBaudRate(QSerialPort::Baud115200);

            if (!serial.open(QIODevice::ReadWrite)) {
                qDebug() << tr("Can't open %1, error code %2").arg(m_portName).arg(serial.error());
                emit error(tr("Can't open %1, error code %2").arg(m_portName).arg(serial.error()));
                return;
            }
            qDebug() << "Serial port" << currentPortName << "opened";
        }

        if (serial.waitForReadyRead(currentWaitTimeout)) {
            QByteArray requestData = serial.readAll();
            while (serial.waitForReadyRead(10))
                requestData += serial.readAll();
            qDebug() << "serial RX:" << requestData.toHex(' ');
            
            if(requestData.at(0) == 0x02 && requestData.at(1) == 0x68 && requestData.at(2) == 0x50 && requestData.at(3) == 0x0b && requestData.at(4) == 0x11 && requestData.length() >= 17) {
                uint16_t convertedData = (requestData.at(10) << 8) | ((uint8_t)requestData.at(9));
                double speed = ((double)convertedData) / 100.0;
                convertedData = (requestData.at(8) << 8) | ((uint8_t)requestData.at(7));
                double cadence = ((double)convertedData) / 2.0;
                uint16_t watt = (requestData.at(14) << 8) | ((uint8_t)requestData.at(13));
                
                qDebug() << "Metrics FROM Serial: Speed" << speed << "Cadence" << cadence << "Watt" << watt;
            }
        }
        m_mutex.lock();
        if (currentPortName != m_portName) {
            currentPortName = m_portName;
            currentPortNameChanged = true;
        } else {
            currentPortNameChanged = false;
        }
        currentWaitTimeout = m_waitTimeout;
        m_mutex.unlock();
    }
}
