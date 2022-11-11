#ifndef CHARACTERISTICWRITEPROCESSOR2AD9_H
#define CHARACTERISTICWRITEPROCESSOR2AD9_H

#include "bluetoothdevice.h"
#include "characteristicnotifier2ad9.h"
#include "characteristicwriteprocessor.h"

class CharacteristicWriteProcessor2AD9 : public CharacteristicWriteProcessor {
    Q_OBJECT
    uint8_t bikeResistanceOffset = 4;
    double bikeResistanceGain = 1.0;
    bluetoothdevice *Bike;
    CharacteristicNotifier2AD9 *notifier = nullptr;

  public:
    explicit CharacteristicWriteProcessor2AD9(double bikeResistanceGain, uint8_t bikeResistanceOffset,
                                              bluetoothdevice *bike, CharacteristicNotifier2AD9 *notifier,
                                              QObject *parent = nullptr);
    virtual int writeProcess(quint16 uuid, const QByteArray &data, QByteArray &out);
    void changeSlope(int16_t slope, uint8_t crr);
    void changePower(uint16_t power);
  signals:
    void changeInclination(double grade, double percentage);
    void slopeChanged();
    void ftmsCharacteristicChanged(const QLowEnergyCharacteristic &characteristic, const QByteArray &newValue);
};

#endif // CHARACTERISTICWRITEPROCESSOR2AD9_H
