---
layout: default
title: Shadowsocks / Trojan 自建 VPN 教程与 2026 现状说明
description: 详解 Shadowsocks (SS/SS-2022)、SSR 与 Trojan 协议在 2026 年自建 VPN 中的真实可用现状与选型建议。
---

# Shadowsocks / Trojan 自建 VPN 与现状说明

> 返回首页：[VPN 搭建与使用指南](./index.html) | [GitHub 仓库](https://github.com/bujiwa/vpn)

很多人在搜索 **VPN 搭建教程** 时，最先看到的往往是 Shadowsocks（SS）、SSR 或 Trojan 的老文章。这一页专门把这几个传统协议在 **2026 年的真实可用情况** 说清楚，避免新手走弯路。

---

## 一、Shadowsocks（SS）与 SSR 现状

- **SSR（ShadowsocksR）**：已经停止维护多年，协议特征早已被精准识别，**不建议再部署**。
- **传统 Shadowsocks（aes-256-gcm 等）**：单独直连海外 VPS 极易触发端口封锁。
- **Shadowsocks-2022（AEAD-2022）**：新版协议修复了重放攻击等漏洞，CPU 占用极低，但在国内直连环境下，通常更适合搭配专线/中转使用，而不适合个人裸连普通 VPS。

如果只是用于学习或配合中转，推荐使用 Rust 版本的 `shadowsocks-rust`，加密方式选择 `2022-blake3-aes-128-gcm` 或 `2022-blake3-aes-256-gcm`。

---

## 二、Trojan 协议现状

**Trojan** 的思路是完全模拟标准 HTTPS 流量：当探测流量访问你的 443 端口时，服务端会把请求转给正常的 Web 站点（Nginx/Caddy），只有携带正确密码的合法 VPN 客户端才会进入代理通道。

### 适用前提
- 必须准备一个域名并配置有效的 TLS 证书；
- 服务端需要同时运行一个正常的 Web 回落站点（Fallback）。

### 为什么现在新手更推荐 Reality？
Trojan 本身依然可用，但你需要额外买域名、配证书和回落站点；而 [VLESS + Reality](./vless-reality.html) 直接省掉了域名和证书环节，配置更简单、隐蔽性也更好。

---

## 三、选型建议总结

1. **想自己搭个人 VPN**：优先选 [VLESS + Reality](./vless-reality.html) 或 [Hysteria2](./hysteria2.html)。
2. **想要现成稳定、免维护的 VPN**：直接看我在首页分享的真实使用经验：[返回 VPN 指南首页](./index.html)。
