---
layout: default
title: Hysteria2 自建高速 VPN 教程（晚高峰与弱网提速）
---

# Hysteria2 自建高速 VPN 教程

> 返回首页：[VPN 搭建与使用指南](./index.html) | [GitHub 仓库](https://github.com/bujiwa/vpn)

如果你的 VPS 线路一般、晚高峰丢包严重，传统 TCP 协议的 **VPN**（如普通 V2Ray）速度往往会断崖式下跌。**Hysteria2** 基于改良版 QUIC（UDP）协议，在高丢包网络环境下提速非常明显，非常适合拿来做“垃圾线路救星”或高速备用 VPN。

---

## 一、前提条件

- 一台海外 VPS（建议开放 UDP 端口，如 `443` 或高位端口，并确认服务商没有封禁 UDP）。
- 可选一个域名（用于自动申请 Let's Encrypt 证书）；如果没有域名，也可以用自签证书（客户端需开启 `skip-cert-verify`）。

---

## 二、一键安装 Hysteria2 服务端

官方提供了一键安装脚本，支持 systemd 管理：

```bash
bash <(curl -fsSL https://get.hy2.sh/)
```

---

## 三、编写配置文件 `/etc/hysteria/config.yaml`

以**有域名自动签发证书**为例（推荐做法）：

```yaml
listen: :443

acme:
  domains:
    - your-domain.com
  email: your-email@example.com

auth:
  type: password
  password: ReplaceWithAStrongPassword

masquerade:
  type: proxy
  proxy:
    url: https://news.ycombinator.com/
    rewriteHost: true
```

启动并设为开机自启：

```bash
systemctl enable hysteria-server.service
systemctl restart hysteria-server.service
systemctl status hysteria-server.service
```

---

## 四、使用 Hysteria2 的真实注意事项

1. **运营商 UDP QoS**：部分地区宽带或校园网在晚高峰会对 UDP 限速，遇到时可以尝试配置端口跳跃（Port Hopping）或切回 [VLESS + Reality](./vless-reality.html)。
2. **带宽参数填写**：在 Clash Verge Rev / Shadowrocket / v2rayN 客户端里，建议如实填写你本地宽带的上下行速率（`up` / `down`），乱填极大值反而容易触发拥塞和断流。

---

## 不想折腾服务器？

想省去买 VPS、配证书、调端口跳跃的麻烦，可以直接看我在首页整理的现成 VPN / 梯子使用体验与避坑建议：[返回 VPN 指南首页](./index.html)。
