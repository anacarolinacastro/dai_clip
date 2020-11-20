# DAI Clip


Generate a FFMPEG command to download the HLS Google DAI ads clip given an [asset key](asset_key).

## Running

```
ruby dai_clip.rb --asset_key=my-asset-key --offset=3 --ogncluster=abc --bitrate=1234567
```


## Options

#### bitrate
Chooses the variant bitrate to be downloaded

Usage:

```
-bBITRATE
```

or

```
--bitrate=BITRATE
```

#### asset_key
Asset key to fetch DAI manifest

Usage:

```
-aASSET_KEY
```

or

```
--asset_key=ASSET_KEY
```

#### ogncluster
User cluster param for segmented AD

Usage:

```
-oOGNCLUSTER
```

or

```
--ogncluster=OGNCLUSTER
```

#### offset
The number of segments of the stream to use before and after the AD

Usage:

```
-OOFFSET
```

or

```
--offset=OFFSET
```

#### output_name
The name for the output file

Usage:

```
-nNAME
```

or

```
--output_name=NAME
```

#### override
Override output file

Usage:

```
-y
```

or

```
--override
```

