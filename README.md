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

Drive link
https://ln5.sync.com/dl/633f463c0/w5f2hutx-nvggz3wv-3gv8pr53-9jcr7kq2

Device Tree 
https://www.linkedin.com/pulse/device-trees-embedded-linux-keroles-khalil/

## Setting Up dev board with custom config 
###uploading images
linux PC
Connect serial cable to host PC
Connect microusb cable to host PC
Press turn off power , press vol+ button and turn on power
use rkchip commands from host PC to rotate

uploading damin image 
sudo ./upgrade_tool uf update-debian.img

uploding kernel 
you can upload the kernel seperately 
sudo ./upgrade_tool di -b boot.img
sudo ip -details link show can0

###


------- CAN0 (as reading from userspace) is connected to can1 in evb ; this is a working no issue log---------------------------------- 
root@linaro-alip:~# sudo ip link set can0 down
root@linaro-alip:~# sudo ip link set can0 type can bitrate 500000[  353.196969] [dhd][wlan0] wl_run_escan : LEGACY_SCAN sync ID: 8, bssidx: 0
root@linaro-alip:~# sudo ip link set can0 up
[  363.276312] [dhd] CFG80211-ERROR) wl_cfg80211_netdev_notifier_call : wdev null. Do nothing
[  363.277339] IPv6: ADDRCONF(NETDEV_UP): can0: link is not ready
[  363.277397] [dhd] CFG80211-ERROR) wl_cfg80211_netdev_notifier_call : wdev null. Do nothing
[  363.277485] IPv6: ADDRCONF(NETDEV_CHANGE): can0: link becomes ready
[  363.277502] [dhd] CFG80211-ERROR) wl_cfg80211_netdev_notifier_call : wdev null. Do nothing

root@linaro-alip:~# sudo ip -details link show can0
2: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
          bitrate 125000 sample-point 0.772
          tq 363 prop-seg 8 phase-seg1 8 phase-seg2 5 sjw 1
          rockchip_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..128 brp-inc 2
          clock 297000000numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

can0: flags=193<UP,RUNNING,NOARP>  mtu 16
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 10  (UNSPEC)
        RX packets 1758  bytes 14064 (13.7 KiB)
        RX errors 60  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 63
----------------------------------------------------------------------------------------------------------
--- issue---

root@linaro-alip:~# sudo ip link set can0 down
root@linaro-alip:~# sudo ip link set can0 type can bitrate 125000
root@linaro-alip:~# sudo ip link set can0 up
[ 4319.582868] rockchip_canfd fe580000.can can0: incorrect/missing data bit-timing

root@linaro-alip:~# sudo ip link set can0 down
root@linaro-alip:~# sudo ip link set can0 type can bitrate 500000
[ 4524.860242] rockchip_canfd fe580000.can can0: bitrate error 0.3%
root@linaro-alip:~# sudo ip link set can0 up
[ 4529.717675] rockchip_canfd fe580000.can can0: incorrect/missing data bit-timing     

2: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
          bitrate 500000 sample-point 0.818
          tq 181 prop-seg 4 phase-seg1 4 phase-seg2 2 sjw 1
          rockchip_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..128 brp-inc 2
          clock 297000000numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
          
----solution---
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

    
------------------------------------------------------------------------------------------------------------


screen rotate
xrandr --output HDMI-1 --rotate left

------------------------------------------------------------------------------------------------------------


