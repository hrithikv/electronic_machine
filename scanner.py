from bluetool import Bluetooth


scanner = Bluetooth()
scanner.scan()
found = scanner.get_available_devices()
print(found)
