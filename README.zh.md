# 轴承动力学仿真与结果分析

[English Version](https://github.com/BiaWei/Bearing-Dynamics/blob/main/README.md) | [简体中文](https://github.com/BiaWei/Bearing-Dynamics/blob/main/README.zh.md)

本文件通过ChatGPT生成，可能存在错误或不准确的地方，请对比源代码查看。

## 项目简介
本项目通过 MATLAB 对轴承系统外圈故障的动力学行为进行建模、仿真和分析。仿真过程中考虑了轴承参数、系统参数以及故障参数等影响因素。程序基于求解轴承动力学的微分方程，输出仿真结果，并通过图形化的方式对结果进行可视化和分析。

## 功能模块
本项目包含以下主要功能：
1. **参数读取**：从 Excel 文件中加载轴承、系统和故障参数。
2. **动力学仿真**：利用 `ode45` 求解轴承动力学的微分方程。
3. **结果保存**：将仿真结果保存为 `.mat` 文件。
4. **结果分析**：生成多种图表，包括位移、速度、接触力和频谱等。

## 使用说明

### 1. 文件结构
- `simulation.m`：主脚本，执行轴承动力学仿真和结果分析。
- `systemparameter/para.xlsx`：系统参数文件，包含轴承、系统和故障参数。
- `results/`：保存仿真结果的目录。
- `resultAnalysis2.m`：结果分析脚本，用于生成图表。

### 2. 子文件介绍

#### model/
- `BearingDynamicModel.m`：轴承的动力学模型

$$ M_{Bearing}\ddot{X} + C_x \dot{X} + K_x X = F_{\text{Initial},x} + F_{\text{Hertz},x} $$
$$ M_{Bearing}\ddot{Y} + C_y \dot{Y} + K_y Y = F_{\text{Initial},y} + F_{\text{Hertz},y} $$
$$ {I_{\text{Equivalent}}} \ddot{\theta} + C_{\text{Outer}} \dot{\theta} = T_{\text{Input}} + T_{\text{Resistance}} $$


#### function/
- `ComputeBallPosition.m`：计算滚动体在指定时间的角位置。
- `ComputeContactForce.m`：计算滚动体的赫兹接触力及总接触力分量。
- `ComputeIAS.m`：计算滚动体和保持架的瞬时角速度及线速度。
- `ComputeNthBallDeformation.m`：计算滚动体的变形，包括故障影响。
- `ComputeRollingResistance.m`：计算滚动体的滚动阻力及对应的阻力转矩。

#### function/DSP
- `EnvSpec.m`：计算信号的包络曲线、包络频谱及均值居中信号。
- `myFFT.m`：计算信号的快速傅里叶变换（FFT）频谱及对应频率轴。

### 3. 参数文件说明
#### 参数表格字段：
- **轴承参数**（`A3:H3`）：包括阻尼、刚度、质量、半径、滚动体数量等。
- **系统参数**（`A7:H7`）：包括外圈阻尼、等效惯量、径向间隙、赫兹接触刚度、输入转矩等。
- **分析参数**（`A12:B12`）：包括仿真时间限制和时间步长。
- **故障参数**（`A16:D16`）：包括故障类型、深度、位置和长度。

### 4. 仿真步骤
1. 运行 `simulation.m`，自动完成以下操作：
   - 从 `systemparameter/para.xlsx` 加载参数。
   - 初始化时间步长和初始状态。
   - 求解轴承动力学微分方程。
   - 将仿真结果保存至 `results/Solution.mat`。
2. 运行 `resultAnalysis.m` 生成结果分析图表。

## 结果分析图表

### 1. 轴承位移随时间变化
- **图示内容**：分别展示轴承在 X 和 Y 方向上的位移随时间的变化。
- **图表特性**：
  - 子图 1：X 方向位移（单位：米）
  - 子图 2：Y 方向位移（单位：米）

![Figure 1](https://raw.githubusercontent.com/BiaWei/Bearing-Dynamics/refs/heads/main/examples/figure1.png "Figure 1")

### 2. 瞬时角速度和转速随时间变化
- **图示内容**：显示内圈瞬时角速度（IAS）及其对应转速随时间的变化。
- **图表特性**：
  - 子图 1：瞬时角速度 IAS（单位：rad/s）
  - 子图 2：转速（单位：RPM）

![Figure 2](https://raw.githubusercontent.com/BiaWei/Bearing-Dynamics/refs/heads/main/examples/figure2.png "Figure 2")

### 3. 瞬时角速度随轴转角的变化
- **图示内容**：展示内圈瞬时角速度（IAS）与轴转角（单位：转数）的关系。
- **图表特性**：
  - 横坐标：轴转角（单位：revolutions）
  - 纵坐标：瞬时角速度 IAS（单位：rad/s）

![Figure 3](https://raw.githubusercontent.com/BiaWei/Bearing-Dynamics/refs/heads/main/examples/figure3.png "Figure 3")

### 4. 滚动体在某时刻的接触力分布
- **图示内容**：在 1.5 秒时刻，各滚动体的接触力分布。
- **图表特性**：
  - 横坐标：滚动体编号
  - 纵坐标：接触力（单位：N）

![Figure 4](https://raw.githubusercontent.com/BiaWei/Bearing-Dynamics/refs/heads/main/examples/figure4.png "Figure 4")

### 5. 滚动体接触力的角度变化
- **图示内容**：展示各滚动体接触力随轴转角的变化。
- **图表特性**：
  - 横坐标：轴转角（单位：revolutions）
  - 纵坐标：接触力（单位：N）
  - 包含所有滚动体的曲线，并标注图例。

![Figure 5](https://raw.githubusercontent.com/BiaWei/Bearing-Dynamics/refs/heads/main/examples/figure5.png "Figure 5")

### 6. 外圈加速度信号的包络曲线
- **图示内容**：展示外圈加速度信号的包络曲线与均值居中信号随时间的变化。
- **图表特性**：
  - 曲线 1：包络曲线（红色）
  - 曲线 2：均值居中信号（蓝色）
  - 横坐标：时间（单位：秒）
  - 纵坐标：幅值

![Figure 6](https://raw.githubusercontent.com/BiaWei/Bearing-Dynamics/refs/heads/main/examples/figure6.png "Figure 6")

### 7. 外圈加速度信号的包络频谱
- **图示内容**：外圈加速度信号的包络频谱随频率变化。
- **图表特性**：
  - 横坐标：频率（单位：Hz）
  - 纵坐标：幅值

模型参数中轴承的外圈故障特征频率为 __77Hz__。
![Figure 7](https://raw.githubusercontent.com/BiaWei/Bearing-Dynamics/refs/heads/main/examples/figure7.png "Figure 7")

### 8. 外圈加速度信号的 FFT 频谱
- **图示内容**：外圈加速度信号的 FFT 频谱，仅显示非负频率部分。
- **图表特性**：
  - 横坐标：频率（单位：Hz）
  - 纵坐标：幅值

![Figure 8](https://raw.githubusercontent.com/BiaWei/Bearing-Dynamics/refs/heads/main/examples/figure8.png "Figure 8")

## 使用环境
- MATLAB 版本：R2020a 或更新版本
- 操作系统：Windows 或 Linux

## 注意事项
1. 确保 `systemparameter/para.xlsx` 文件路径正确，且格式符合要求。
2. 图表保存时，请确保 `results/` 目录存在，避免保存失败。

## 贡献
如需扩展或修改本项目，请在提交前确保：
- 提供详细的代码注释和功能说明。
- 测试所有更改是否与现有功能兼容。

---

感谢您的使用！如有问题，请联系开发者。
