*This documentation is constantly updated as I learn and practice new areas in the domain of Embedded Linux, networking, troubleshooting and best practices. And also this will serve as a short-note for all the commands and research I'm doing. And I wish this shall be a knowledge hub for anyone interested in these topics*
# Linux-based Embedded Systems
## Networking
### Networking Fundamentals
#### How a ping works based on Debian/ubuntu systems and raspbian systems 

![Network Diagram](https://github.com/kasunvj/SoMs-Im-working-on/blob/main/images/net.jpg?raw=true)

#### Sharing Internet over Ethernet

![Interent sharing](https://github.com/kasunvj/SoMs-Im-working-on/blob/main/images/dnsmsq%20(1).jpg?raw=true)

### WiFi
### 4G

# RK3568 

This is sort of a log on the go, while settin up the SOM. I noted down to repetitive commands and procedures here.  

Drive link
https://ln5.sync.com/dl/633f463c0/w5f2hutx-nvggz3wv-3gv8pr53-9jcr7kq2

Device Tree 
https://www.linkedin.com/pulse/device-trees-embedded-linux-keroles-khalil/

## Setting Up dev board with custom config 

### Uploading base image and kernel
linux PC
Connect serial cable to host PC
Connect microusb cable to host PC
Press turn off power , press vol+ button and turn on power
use rkchip commands from host PC to rotate

uploading damin image 
```
sudo ./upgrade_tool uf update-debian.img
```
uploding kernel 
you can upload the kernel seperately 
```
sudo ./upgrade_tool di -b boot.img
```
### Systemd services 
```
sudo systemctl enable my-service.service
sudo systemctl start my-service.service
```

### Connect to internt using `nmcli`/`nmtui`

Useful commands 
`nmcli device wifi list`
`nmcli device wifi connect "SSID_NAME" password "YOUR_PASSWORD"`
`nmcli connection modify "SSID_NAME" connection.autoconnect yes`

### Adding dabian pacakages to source
`sudo nano /etc/apt/sources.list`
```
# Debian 10 Buster repositories
deb [arch=arm64] http://deb.debian.org/debian/ buster main contrib non-free
deb [arch=arm64] http://deb.debian.org/debian/ buster-updates main contrib non-free
deb [arch=arm64] http://deb.debian.org/debian-security buster/updates main contrib non-free
```


### Setting windowing server 
There are two types of servers. `X11(Xorg)` or `walyland`
Find your server using `echo $XDG_SESSION_TYPE`. You have to fun this in grahical interface to find out. if you use login console, what you will get of `tty`. `X11`uses `.xinitrc` in home (~) when called by `startx` or `xinit`. Sample file is located at /RK3568/windowing server. startx can be run at boot by adding the command to `~/.bash_profile`

*XOrg Server* 

```
sudo apt-get install --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox
```

Disabling light display manager
You have to disable your desktop environment using `systemctl disable lightdm`. Once you do, after a boot your desktop env will not appear. But still the windowing server is directed to light dm. you can verify it by running `startx` which immediately opens up your lightdm destop env.



### Installing lightweight browser
I used Midori browser.
```
 sudo apt-get install midori
```
Configuration for that browser is located at `~/.config/midori/config`


screen rotate
xrandr --output HDMI-1 --rotate left



### Configure CAN from device tree

canfd-1.0:

CAN FD (Flexible Data-rate): canfd-1.0 refers to CAN controllers that support the CAN FD protocol, which is an extension of the classic CAN protocol. CAN FD allows:
Higher data rates (up to 8 Mbps, compared to the classic CAN 1 Mbps limit).
Larger payloads per frame (up to 64 bytes instead of 8 bytes in classic CAN).
The canfd-1.0 designation likely refers to a CAN FD controller version supported by Rockchip or a similar standard (e.g., Bosch CAN FD 1.0).
In your DTS snippet, can0 and can2 are using canfd-1.0, which suggests they support CAN FD.
can-1.0:

Classic CAN: can-1.0 represents controllers that support the standard or "classic" CAN protocol. Classic CAN has a lower data rate and is limited to 8 bytes per frame.
This controller type is typically sufficient for standard automotive and industrial CAN applications where high data rates or larger payloads aren’t required.
In your DTS snippet, can1 is designated as can-1.0, indicating it only supports the classic CAN protocol.


can0: can@fe570000 {
		compatible = "rockchip,canfd-1.0";
		reg = <0x0 0xfe570000 0x0 0x1000>;
		interrupts = <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>;
		clocks = <&cru CLK_CAN0>, <&cru PCLK_CAN0>;
		clock-names = "baudclk", "apb_pclk";
		resets = <&cru SRST_CAN0>, <&cru SRST_P_CAN0>;
		reset-names = "can", "can-apb";
		tx-fifo-depth = <1>;
		rx-fifo-depth = <6>;
		status = "disabled";
	};

	can1: can@fe580000 {
		compatible = "rockchip,canfd-1.0";❌️
		compatible = "rockchip,can-1.0";✅️
		reg = <0x0 0xfe580000 0x0 0x1000>;
		interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;
		clocks = <&cru CLK_CAN1>, <&cru PCLK_CAN1>;
		clock-names = "baudclk", "apb_pclk";
		resets = <&cru SRST_CAN1>, <&cru SRST_P_CAN1>;
		reset-names = "can", "can-apb";
		tx-fifo-depth = <1>;
		rx-fifo-depth = <6>;
		status = "disabled";
	};

	can2: can@fe590000 {
		compatible = "rockchip,canfd-1.0";
		reg = <0x0 0xfe590000 0x0 0x1000>;
		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
		clocks = <&cru CLK_CAN2>, <&cru PCLK_CAN2>;
		clock-names = "baudclk", "apb_pclk";
		resets = <&cru SRST_CAN2>, <&cru SRST_P_CAN2>;
		reset-names = "can", "can-apb";
		tx-fifo-depth = <1>;
		rx-fifo-depth = <6>;
		status = "disabled";
	}; what is canfd-1.0 and can-1.0


### Configure CAN
```
Usage: ip link set DEVICE type can
        [ bitrate BITRATE [ sample-point SAMPLE-POINT] ] |
        [ tq TQ prop-seg PROP_SEG phase-seg1 PHASE-SEG1
          phase-seg2 PHASE-SEG2 [ sjw SJW ] ]

        [ dbitrate BITRATE [ dsample-point SAMPLE-POINT] ] |
        [ dtq TQ dprop-seg PROP_SEG dphase-seg1 PHASE-SEG1
          dphase-seg2 PHASE-SEG2 [ dsjw SJW ] ]
        [ tdcv TDCV tdco TDCO tdcf TDCF ]

        [ loopback { on | off } ]
        [ listen-only { on | off } ]
        [ triple-sampling { on | off } ]
        [ one-shot { on | off } ]
        [ berr-reporting { on | off } ]
        [ fd { on | off } ]
        [ fd-non-iso { on | off } ]
        [ presume-ack { on | off } ]
        [ cc-len8-dlc { on | off } ]
        [ tdc-mode { auto | manual | off } ]

        [ restart-ms TIME-MS ]
        [ restart ]

        [ termination { 0..65535 } ]

        Where: BITRATE  := { NUMBER in bps }
                  SAMPLE-POINT  := { 0.000..0.999 }
                  TQ            := { NUMBER in ns }
                  PROP-SEG      := { NUMBER in tq }
                  PHASE-SEG1    := { NUMBER in tq }
                  PHASE-SEG2    := { NUMBER in tq }
                  SJW           := { NUMBER in tq }
                  TDCV          := { NUMBER in tc }
                  TDCO          := { NUMBER in tc }
                  TDCF          := { NUMBER in tc }
                  RESTART-MS    := { 0 | NUMBER in ms }
  
```
### CAN Debug Commands
```
sudo ip -details link show can0
```
```
ip -d -s link show can0

root@linaro-alip:/home/linaro# ip -d -s link show can0
2: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
          bitrate 500000 sample-point 0.850
          tq 100 prop-seg 8 phase-seg1 8 phase-seg2 3 sjw 1
          rockchip_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..128 brp-inc 2
          clock 100000000
          re-started bus-errors arbit-lost error-warn error-pass bus-off
          0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
    RX: bytes  packets  errors  dropped overrun mcast
    456        57       0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    0          0        0       0       0       0


```
