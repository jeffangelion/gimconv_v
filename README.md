# gimconv_v
My attempt of open source implementation of GimConv in V

## Why?
I'm tired of Sony's GimConv (available in web.archive.org only) and its mess of optional arguments

I just want indexed GIM -> indexed PNG -> indexed GIM, okay?

#### License: GPLv3+

## GIM image structure
> Note: data can be both little or big endian

### GIM image header
|Offset|Length|Description                             |
|------|------|----------------------------------------|
|0     |8     |File signature: `MIG.00.1` or `.GIM1.00`|
|8     |4     |Format style: `STD`, `PS3`, `PSP`       |
|12    |4     |Padding                                 |

### Block headers (generic)
|Offset|Length|Description                             |
|------|------|----------------------------------------|
|0     |2     |Block type: root (`0x02`), picture (`0x03`), image (`0x04`), palette (`0x05`), fileinfo (`0xff`)|
|2     |2     |?Padding?                               |
|4     |4     |Size of this block + children blocks    |
|8     |4     |Next block relative offset              |
|12    |4     |Block data relative offset              |

### Root (`0x02`)
Parent block for picture (`0x03`) and fileinfo (`0xff`) blocks

### Picture (`0x03`)
Parent block for image (`0x04`) and palette (`0x05`) blocks

### Image (`0x04`)
|Offset|Length|Description                             |
|------|------|----------------------------------------|
|0     |2     |Block data length                       |
|2     |2     |?Padding?                               |
|4     |2     |[Image format](#image-formats)          |
|6     |2     |Pixel order: `0x00` - normal, `0x01` - faster|
|8     |2     |Image width in pixels|
|10    |2     |Image heigth in pixels|
|12    |2     |Image ?BPP alignment?|
|14    |2     |Image ?pitch alignment?| <!--  -->
|16    |2     |Image ?heigth alignment?|
|18    |6     |?Padding?|
|24    |4     |Index relative start offset|
|28    |4     |First plane/level/frame relative start offset|
|32    |4     |Last plane/level/frame relative end offset|
|36    |4     |?Color for alpha mask?|
|40    |2     |Level type: `0x01` - MIPMAP, `0x02` - MIPMAP2 (for palettes)|
|42    |2     |Number of levels|
|44    |2     |Frame type: `0x03` - SEQUENCE|
|46    |2     |Frame count|
|48    |4     |?Frame offset?| <!-- Optional user data skipped -->
|52    |var   |Padding (mod 16 = 0)|
|52+var|var2  |Block data|

### Palette (`0x05`)
+ Used if image format 0x04 - 0x07
+ Have same structure with image (`0x04`) block
+ Supported image formats: 0x00 - 0x03
+ Level length: 256 pixels (width - `0x100`, heigth - `0x01`)
+ Up to 4 bytes per pixel (rgba8888 - 4, rgba4444/rgba5551/rgba5650 - 2)
+ Level type - `0x02` (MIPMAP2)

#### Image formats
|Code |Name    |Description                               |
|-----|--------|------------------------------------------|
|0x00 |rgba5650|16 bit: 5 bit red, 6 bit green, 5 bit blue|
|0x01 |rgba5551|16 bits: 5 bit red/green/blue, 1 bit alpha|
|0x02 |rgba4444|16 bits: 4 bit red/green/blue/alpha       |
|0x03 |rgba8888|32 bits: 8 bit red/green/blue/alpha       |
|0x04 |index4  |16 indexed colours                        |
|0x05 |index8  |256 indexed colours                       |
|0x06 |index16 |16 indexed colours ?with alpha?           |
|0x07 |index32 |256 indexed colours ?with alpha?          |
<!-- https://en.wikipedia.org/wiki/DirectDraw_Surface -->
<!-- https://en.wikipedia.org/wiki/S3_Texture_Compression -->
<!-- |0x08 |dxt1    |???| -->
<!-- |0x09 |dxt3    |???| -->
<!-- |0x0A |dxt5    |???| -->
<!-- |0x108|dxt1ext |???| -->
<!-- |0x109|dxt3ext |???| -->
<!-- |0x10A|dxt5ext |???| -->
