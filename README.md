# d2uhf

Plugin for working with UHF module Senter type D2 for working with tags in accordance with the standard ISO / IEC 18000-6: 2013 type C
Works on IQTAB8 (IQTAB81DZU) tablet
## Supports:
- Reader power reading mode
- Reader power value recording mode
- The mode of reading the label value from the EPC bank.

First of all, you need to initialize the device
onInit()

```
Future<bool> _onInit() async {
    bool success = false;
    try {
      success = (await D2uhf.onInit)!;
    } on PlatformException {
      success = false;
    }
    return _isSuccess = success;
}
```

Then you can already execute commands for reading and writing data

For Russian version see [README_RU.md]

