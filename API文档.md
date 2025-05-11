# API文档
以下是为“旅途助手”iOS应用设计的 **API文档**，基于后端技术栈（**Node.js + Express**）和数据库（**MySQL**）。文档涵盖核心功能相关的API接口，包含请求方法、路径、参数、响应格式及错误处理，旨在为前后端开发提供清晰的对接指引。API设计遵循RESTful风格，使用JSON格式传输数据，认证采用JWT。

-----

## Wayfarer+ API 文档

### 1. 概述

**API 基础信息**：

- **基地址**：`https://api.wayfarer.aiqji.cn/v1`
- **认证**：大部分接口需携带JWT Token，格式为`Authorization: Bearer <token>`。
- **内容类型**：请求和响应均为`application/json`。
- **错误码**：使用HTTP状态码，错误响应包含`error`字段说明。
- **版本**：v1（后续迭代可扩展）。

**技术栈**：

- 后端：Node.js + Express。
- 数据库：MySQL（通过Sequelize ORM操作）。
- 文件存储：目前存于服务器，后期存到专门存储图片的云厂家（图片上传）。
- 推送：Apple Push Notification Service（APNs）。

**通用响应格式**：

```json
{
  "status": "success" | "error",
  "data": { ... } | null,
  "message": "操作成功" | "错误描述",
  "timestamp": "2025-05-10T12:00:00Z"
}
```

**通用错误码**：

- `400`：请求参数错误。
- `401`：未授权（Token无效或缺失）。
- `403`：禁止访问（权限不足）。
- `404`：资源不存在。
- `500`：服务器内部错误。

-----

### 2. API 列表

#### 2.1 用户管理

##### 2.1.1 用户注册

- **描述**：创建新用户账户。
- **方法**：`POST`
- **路径**：`/users/register`
- **请求头**：无
- **请求体**：
  
  ```json
  {
    "username": "string", // 用户名，唯一，4-20字符
    "email": "string", // 邮箱，合法格式
    "password": "string" // 密码，6-20字符
  }
  ```
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "user_id": 1,
        "username": "travellover",
        "email": "user@example.com",
        "created_at": "2025-05-10T12:00:00Z"
      },
      "message": "注册成功",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（400）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "邮箱已存在",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
- **注意**：密码使用bcrypt哈希存储。

##### 2.1.2 用户登录

- **描述**：用户登录并获取JWT Token。
- **方法**：`POST`
- **路径**：`/users/login`
- **请求头**：无
- **请求体**：
  
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "user_id": 1,
        "username": "travellover",
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
      },
      "message": "登录成功",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（401）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "邮箱或密码错误",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```

##### 2.1.3 获取用户信息

- **描述**：获取当前用户信息。
- **方法**：`GET`
- **路径**：`/users/me`
- **请求头**：`Authorization: Bearer <token>`
- **请求体**：无
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "user_id": 1,
        "username": "travellover",
        "email": "user@example.com",
        "avatar_url": "https://s3.amazonaws.com/avatars/1.jpg",
        "created_at": "2025-05-10T12:00:00Z"
      },
      "message": "获取用户信息成功",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（401）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "未授权",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```

#### 2.2 攻略管理

##### 2.2.1 获取攻略列表

- **描述**：获取攻略列表，支持分页、排序、筛选。
- **方法**：`GET`
- **路径**：`/guides`
- **请求头**：无（公开接口）
- **查询参数**：
  - `page`：页码，默认1。
  - `limit`：每页数量，默认10，最大50。
  - `city`：城市名称（可选，如“Paris”）。
  - `tags`：标签，逗号分隔（可选，如“美食,文化”）。
  - `sort`：排序方式，默认`usage_count_desc`（支持`created_at_desc`, `usage_count_asc`）。
- **请求示例**：`/guides?page=1&limit=10&city=Paris&tags=美食&sort=usage_count_desc`
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "total": 100,
        "page": 1,
        "limit": 10,
        "guides": [
          {
            "guide_id": 1,
            "title": "巴黎三日游攻略",
            "city": "Paris",
            "tags": ["美食", "文化"],
            "usage_count": 1234,
            "author": {
              "user_id": 1,
              "username": "travellover"
            },
            "created_at": "2025-05-10T12:00:00Z"
          },
          ...
        ]
      },
      "message": "获取攻略列表成功",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（400）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "无效的页码",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```

##### 2.2.2 获取攻略详情

- **描述**：获取指定攻略的详细信息。
- **方法**：`GET`
- **路径**：`/guides/:id`
- **请求头**：无
- **路径参数**：
  - `id`：攻略ID。
- **请求示例**：`/guides/1`
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "guide_id": 1,
        "title": "巴黎三日游攻略",
        "content": "<p>Day 1: 参观卢浮宫...</p>",
        "city": "Paris",
        "attractions": [
          { "name": "卢浮宫", "coordinates": { "lat": 48.8606, "lng": 2.3376 } }
        ],
        "tags": ["美食", "文化"],
        "usage_count": 1234,
        "author": {
          "user_id": 1,
          "username": "travellover"
        },
        "created_at": "2025-05-10T12:00:00Z"
      },
      "message": "获取攻略详情成功",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（404）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "攻略不存在",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```

##### 2.2.3 创建攻略

- **描述**：用户发布新攻略。
- **方法**：`POST`
- **路径**：`/guides`
- **请求头**：`Authorization: Bearer <token>`
- **请求体**：
  
  ```json
  {
    "title": "string", // 攻略标题，5-100字符
    "content": "string", // 富文本内容
    "city": "string", // 城市名称
    "attractions": [ // 景点列表
      { "name": "string", "coordinates": { "lat": number, "lng": number } }
    ],
    "tags": ["string"], // 标签数组
    "images": ["string"] // 图片URL数组（通过上传接口获取）
  }
  ```
- **响应**：
  - **成功（201）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "guide_id": 1,
        "title": "巴黎三日游攻略",
        "city": "Paris",
        "created_at": "2025-05-10T12:00:00Z"
      },
      "message": "攻略创建成功，待审核",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（400）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "标题不能为空",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```

##### 2.2.4 使用攻略

- **描述**：用户点击“使用该方案”，记录攻略使用并添加到“我的旅游”。
- **方法**：`POST`
- **路径**：`/guides/:id/use`
- **请求头**：`Authorization: Bearer <token>`
- **路径参数**：
  - `id`：攻略ID。
- **请求体**：无
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "guide_id": 1,
        "usage_count": 1235
      },
      "message": "攻略已添加到我的旅游",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（404）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "攻略不存在",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
- **逻辑**：更新`Guide.usage_count`+1，插入`UserGuide`记录（status=“未开始”）。

#### 2.3 我的旅游

##### 2.3.1 获取我的旅游列表

- **描述**：获取用户已选择的攻略列表。
- **方法**：`GET`
- **路径**：`/user/guides`
- **请求头**：`Authorization: Bearer <token>`
- **查询参数**：
  - `status`：状态（可选：`pending`|`ongoing`|`completed`）。
  - `page`：页码，默认1。
  - `limit`：每页数量，默认10。
- **请求示例**：`/user/guides?status=pending&page=1&limit=10`
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "total": 5,
        "page": 1,
        "limit": 10,
        "guides": [
          {
            "guide_id": 1,
            "title": "巴黎三日游攻略",
            "city": "Paris",
            "status": "pending",
            "created_at": "2025-05-10T12:00:00Z"
          },
          ...
        ]
      },
      "message": "获取我的旅游列表成功",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（401）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "未授权",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```

##### 2.3.2 开始旅行

- **描述**：用户确认开始旅行，更新攻略状态。
- **方法**：`POST`
- **路径**：`/user/guides/:id/start`
- **请求头**：`Authorization: Bearer <token>`
- **路径参数**：
  - `id`：攻略ID。
- **请求体**：无
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "guide_id": 1,
        "status": "ongoing"
      },
      "message": "旅行开始",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（404）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "攻略不存在",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
- **逻辑**：更新`UserGuide.status`为“ongoing”。

##### 2.3.3 完成旅行

- **描述**：用户标记旅行完成。
- **方法**：`POST`
- **路径**：`/user/guides/:id/complete`
- **请求头**：`Authorization: Bearer <token>`
- **路径参数**：
  - `id`：攻略ID。
- **请求体**：无
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "guide_id": 1,
        "status": "completed"
      },
      "message": "旅行完成",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（404）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "攻略不存在",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
- **逻辑**：更新`UserGuide.status`为“completed”。

#### 2.4 文件上传

##### 2.4.1 上传图片

- **描述**：上传攻略中的图片至AWS S3。
- **方法**：`POST`
- **路径**：`/upload/images`
- **请求头**：`Authorization: Bearer <token>`
- **请求体**：FormData，包含字段`image`（文件类型）。
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "url": "https://s3.amazonaws.com/images/guide1.jpg"
      },
      "message": "图片上传成功",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（400）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "文件格式不支持",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
- **注意**：支持格式（jpg, png），最大5MB，Node.js使用Multer处理。

#### 2.5 位置提醒

##### 2.5.1 更新用户位置

- **描述**：前端定期上传用户位置，后端检测是否触发提醒。
- **方法**：`POST`
- **路径**：`/user/location`
- **请求头**：`Authorization: Bearer <token>`
- **请求体**：
  
  ```json
  {
    "latitude": number, // 当前纬度
    "longitude": number // 当前经度
  }
  ```
- **响应**：
  - **成功（200）**：
    
    ```json
    {
      "status": "success",
      "data": {
        "matched_guides": [
          {
            "guide_id": 1,
            "city": "Paris"
          }
        ]
      },
      "message": "位置更新成功",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
  - **失败（400）**：
    
    ```json
    {
      "status": "error",
      "data": null,
      "message": "无效的经纬度",
      "timestamp": "2025-05-10T12:00:00Z"
    }
    ```
- **逻辑**：
  - 后端匹配用户位置与`Guide.city`的坐标（半径10km）。
  - 若匹配，触发APNs推送，通知前端显示“是否开始旅行”。

-----

### 3. 认证与安全

- **JWT认证**：
  - 登录后返回Token，有效期7天。
  - 存储于前端Keychain，请求时添加至Header。
  - 后端使用`jsonwebtoken`库验证。
- **安全措施**：
  - HTTPS：所有请求强制使用TLS 1.3。
  - 输入校验：使用`express-validator`防止XSS、SQL注入。
  - 密码加密：bcrypt哈希（salt rounds=10）。
  - 限流：使用`express-rate-limit`，每IP每分钟100次请求。
- **隐私**：
  - 位置数据仅用于提醒，存储加密，遵守GDPR。
  - 用户可通过设置禁用位置上传。

-----

### 4. 数据库交互

- **ORM**：Sequelize，映射MySQL表。
- **事务**：
  - 创建攻略：事务确保`Guide`和`Location`表一致。
  - 使用攻略：事务更新`Guide.usage_count`和插入`UserGuide`。
- **索引**：
  - `Guide.city`：加速城市筛选。
  - `Guide.usage_count`：优化排序。
  - `UserGuide.user_id`：加速用户攻略查询。
- **缓存**：
  - Redis存储热门攻略列表（TTL 1小时）。
  - 排行榜数据每5分钟更新。

-----

### 5. 错误处理

- **统一错误格式**：
  
  ```json
  {
    "status": "error",
    "data": null,
    "message": "具体错误描述",
    "timestamp": "2025-05-10T12:00:00Z"
  }
  ```
- **常见错误**：
  - 参数缺失：`400`，“缺少必填字段”。
  - Token失效：`401`，“请重新登录”。
  - 服务器错误：`500`，“服务器繁忙，请稍后重试”。

-----

### 6. 扩展性

- **多语言**：响应支持`Accept-Language`头，返回不同语言的`message`。
- **分页优化**：支持游标分页（cursor-based）以处理大数据量。
- **WebSocket**：后续可添加实时评论通知。

-----

### 7. 示例代码（Node.js）

以下为`/guides/:id/use`接口的Express实现示例：

```javascript
const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { Guide, UserGuide } = require('../models');
const Sequelize = require('sequelize');

// 使用攻略
router.post('/:id/use', authenticate, async (req, res) => {
  const { id } = req.params;
  const userId = req.user.id;

  try {
    const guide = await Guide.findByPk(id);
    if (!guide) {
      return res.status(404).json({
        status: 'error',
        data: null,
        message: '攻略不存在',
        timestamp: new Date().toISOString(),
      });
    }

    // 事务：更新使用量 + 插入用户攻略记录
    await Sequelize.transaction(async (t) => {
      await Guide.update(
        { usage_count: guide.usage_count + 1 },
        { where: { guide_id: id }, transaction: t }
      );
      await UserGuide.create(
        { user_id: userId, guide_id: id, status: 'pending' },
        { transaction: t }
      );
    });

    return res.status(200).json({
      status: 'success',
      data: { guide_id: id, usage_count: guide.usage_count + 1 },
      message: '攻略已添加到我的旅游',
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: 'error',
      data: null,
      message: '服务器错误',
      timestamp: new Date().toISOString(),
    });
  }
});

module.exports = router;
```

-----

### 8. 测试建议

- **单元测试**：使用Jest测试API逻辑（如认证、参数校验）。
- **集成测试**：Postman或Supertest模拟请求，验证响应。
- **压力测试**：使用Apache JMeter，测试高并发下排行榜查询性能。
- **安全测试**：SQLMap检测注入漏洞，Burp Suite测试XSS。

-----

### 9. 总结

本API文档覆盖了“旅途助手”核心功能（用户管理、攻略管理、我的旅游、文件上传、位置提醒），基于Node.js+Express和MySQL设计，接口清晰、响应统一，兼顾安全与扩展性。文档提供了详细的请求/响应示例及错误处理，适合前后端对接开发。如需补充特定接口（如评论、搜索优化）或提供Swagger/OpenAPI格式，请告知！

-----

如果您需要进一步细化某个接口、生成Swagger文件或前端调用示例，请提供更多要求！