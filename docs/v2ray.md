---
layout: default
title: V2Ray / Xray 自建 VPN 教程（含 WS + TLS 套 CDN 思路）
---

# V2Ray / Xray 自建 VPN 教程（WS + TLS + CDN）

> 返回首页：[VPN 搭建与使用指南](./index.html) | [GitHub 仓库](https://github.com/bujiwa/vpn)

**V2Ray**（以及目前更活跃的分支 **Xray**）是过去几年最经典的 **VPN** 代理内核。现在单纯的 VMess 裸奔不建议再用，但 **VLESS/VMess + WebSocket + TLS + CDN（如 Cloudflare）** 依然是非常实用的方案——最大价值在于：**哪怕你的 VPS IP 被拦截了，套上 CDN 后依然能救活继续用**。

---

## 一、核心架构原理

```text
本地 VPN 客户端 ──(HTTPS/WS)──▶ Cloudflare CDN ──(TLS)──▶ Nginx / Caddy ──▶ Xray/V2Ray
```

因为客户端直接连接的是 Cloudflare 的全球边缘节点 IP，而不是你的 VPS 源站 IP，所以即便源站 IP 无法直连，也能通过 CDN 中转恢复连接。

---

## 二、准备条件

1. 一个托管在 Cloudflare 的域名（开启橙色云朵代理模式）。
2. 一台海外 VPS（Debian / Ubuntu）。
3. 在 Cloudflare SSL/TLS 设置中选择 **Full (strict)** 模式。

---

## 三、核心配置要点

1. **安装 Xray/V2Ray**（参考 [VLESS + Reality 教程](./vless-reality.html) 中的官方脚本）。
2. **服务端监听本地回环端口**（例如 `127.0.0.1:10000`），传输方式选 `ws`（WebSocket），设置一个不易被猜到的 `path`（如 `/assets-stream-9x2a`）。
3. **前端用 Caddy 或 Nginx 反代**：
   - 正常网页访问返回静态页面（伪装成普通博客/工具站）；
   - 命中特定 `path` 的 WebSocket 请求转发给 `127.0.0.1:10000`。

Caddy 示例片段（自动申请并续期 SSL 证书，比手动配 Nginx 省心很多）：

```caddyfile
vpn.your-domain.com {
    @ws {
        path /assets-stream-9x2a
    }
    reverse_proxy @ws 127.0.0.1:10000
    respond "Welcome" 200
}
```

---

## 四、优缺点实话实说

- **优点**：抗封锁极强，IP 被墙也能救活，非常适合作为“保底备用 VPN”。
- **缺点**：走免费 Cloudflare CDN 时，国内晚高峰延迟通常较高、速度一般，不太适合当日常高速主力。

如果你更看重日常看视频、查资料、用 AI 的流畅体验，又不想花高价买 CN2 线路自建，可以参考首页我整理的自用平价方案：[查看 VPN 省心方案](./index.html)。
