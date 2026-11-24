---
layout: default
title: VLESS + Reality 自建个人 VPN 教程（2026 免域名）
---

# VLESS + Reality 自建个人 VPN 教程（免域名）

> 返回首页：[VPN 搭建与使用指南](./index.html) | [GitHub 仓库](https://github.com/bujiwa/vpn)

**VLESS + Reality** 是目前（2026 年）个人自建 **VPN** 最省心、抗封锁能力最强的方案之一。它最大的优点是**不需要自己买域名，也不需要申请 SSL 证书**，直接把 VPN 流量伪装成访问大型正规 HTTPS 网站的正常 TLS 握手，隐蔽性远超传统代理协议。

---

## 一、准备工作

1. 一台海外 VPS（推荐 Debian 12 或 Ubuntu 22.04/24.04，内存 512MB 以上即可）。
2. 能够通过 SSH 登录到 VPS（Windows 可用 PowerShell / WindTerm，macOS 直接用终端）。
3. 放行防火墙的 `443` TCP 端口。

---

## 二、开启 BBR 加速（强烈建议）

登录 VPS 后，先开启 Linux 内核自带的 BBR 拥塞控制，能明显改善个人 VPN 的 TCP 传输速度：

```bash
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
# 检查是否生效，输出包含 bbr 即成功
sysctl net.ipv4.tcp_congestion_control
```

---

## 三、安装 Xray-core 并配置 VLESS-Reality

### 1. 安装官方 Xray-core

```bash
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
```

### 2. 生成 UUID 与 Reality 密钥对

```bash
# 生成 UUID
xray uuid

# 生成 X25519 公钥和私钥（Private key 放服务端，Public key 填客户端）
xray x25519

# 生成 8 位随机 shortId
openssl rand -hex 4
```

### 3. 写入服务端配置 `/usr/local/etc/xray/config.json`

下面是一份精简可用的 VLESS + Vision + Reality 配置模板，替换 `<你的UUID>`、`<你的PrivateKey>` 和 `<你的ShortId>`：

```json
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "<你的UUID>",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "www.microsoft.com:443",
          "xver": 0,
          "serverNames": ["www.microsoft.com"],
          "privateKey": "<你的PrivateKey>",
          "shortIds": ["<你的ShortId>"]
        }
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct" }
  ]
}
```

### 4. 启动并设置开机自启

```bash
systemctl enable xray
systemctl restart xray
systemctl status xray
```

---

## 四、踩坑经验提醒

- **伪装目标域名（dest / serverNames）**：尽量挑选支持 **TLS 1.3 + H2**、且和你的 VPS 同地区或延迟较低的大型网站，不要挑冷门小站。
- **时间同步**：客户端和服务器系统时间误差超过 90 秒会导致握手失败，建议在 VPS 上确认 `timedatectl` 时间准确。
- **客户端选择**：详见 [全平台 VPN 客户端配置指南](./clients.html)。

---

## 懒得折腾自建 VPN？

如果只是日常查资料、用 ChatGPT 或看流媒体，自己维护 VPS 的成本和精力其实不低。我目前是自建当备用，主力用现成的平价 VPN 服务，具体避坑经验和个人在用方案整理在首页：[查看 VPN 省心替代方案](./index.html)。
