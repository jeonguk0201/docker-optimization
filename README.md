# Docker-optimization 🚀

## 소개 📖
이 프로젝트는 **Docker 컨테이너의 최적화 과정**을 단계별로 수행한 실습 프로젝트입니다. Node.js 애플리케이션을 Docker로 컨테이너화하고, 여러 최적화 기법을 적용하여 이미지를 경량화하였습니다. 이미지의 크기를 줄임으로써 **빌드 시간 단축, 스토리지 절약, 네트워크 전송 속도 향상**과 같은 효과를 얻었습니다.

## 기획 📝
Docker 이미지 최적화는 배포 및 관리 효율성을 높이기 위해 필수적인 작업입니다. 

- **이미지 크기 줄이기**: 경량화된 이미지를 사용하여 배포 및 실행 속도를 개선.
- **불필요한 파일 제외**: `.dockerignore` 파일을 사용하여 이미지에 포함되지 않아야 할 파일 제거.
- **효율적인 베이스 이미지 선택**: 용량을 줄이기 위해 기본 이미지를 Alpine 기반으로 전환.

목표는 단계별 최적화 과정을 통해 **이미지 용량을 최소화**하고, 최적화 전후의 변화를 측정하여 최종 성과를 확인하는 것이었습니다.

## 설계 🛠
### 1. 기본 구조
프로젝트는 Node.js 기반의 간단한 Express 애플리케이션을 포함합니다. 애플리케이션이 Docker 컨테이너 내부에서 실행되며, 브라우저를 통해 접근할 수 있습니다. 구조는 다음과 같습니다:

![image](https://github.com/user-attachments/assets/7ff14242-8899-4737-a8e3-897fffa3f489)



- **`app/`** 디렉토리에는 Node.js 애플리케이션 파일이 포함됩니다.
- **`Dockerfile`**: 최적화 전의 Docker 빌드 설정을 포함.
- **`Dockerfile.optimized`**: 최적화된 Docker 빌드 설정을 포함.
- **`.dockerignore`**: 불필요한 파일들을 제외하여 이미지 용량을 줄이기 위한 설정.

### 2. 기술 스택
- **Docker**: 컨테이너화 도구.
- **Node.js**: 서버 애플리케이션 환경.
- **Express**: 간단한 HTTP 서버 구축.

## 구축 ⚙️
#### 1. 기본 이미지 구축
최적화하기 전에 먼저 **기본 이미지**를 구축합니다. Node.js의 표준 이미지인 `node:16`을 사용하여 이미지를 빌드하고, 이미지의 크기 및 실행 상태를 확인합니다.

#### Dockerfile (기본)
```dockerfile
FROM node:16

WORKDIR /usr/src/app

COPY app/package*.json ./

RUN npm install

COPY app/ .

EXPOSE 3000

CMD ["npm", "start"]
```
#### 1.2 각 명령어 설명 

- **`FROM node:16`**:  
  Docker 이미지 빌드를 시작할 때는 기본이 되는 베이스 이미지를 선택합니다. 여기서는 Node.js 16 버전을 포함한 이미지를 사용합니다. Docker 허브에 있는 공개된 이미지를 사용할 수 있습니다.

- **`WORKDIR /usr/src/app`**:  
  WORKDIR는 작업 디렉토리를 설정하는 명령어입니다. 이 디렉토리에서 이후 명령들이 실행됩니다.

- **`COPY app/package*.json ./`**:  
  로컬 머신에 있는 `package.json` 파일을 Docker 이미지의 `/usr/src/app` 디렉토리로 복사합니다.

- **`RUN npm install`**:  
  `npm install` 명령어를 실행해 `package.json`에 명시된 의존성 패키지를 설치합니다. 이때 `node_modules` 폴더가 생성됩니다.

- **`COPY app/ .`**:  
  애플리케이션의 나머지 코드를 복사합니다.

- **`EXPOSE 3000`**:  
  애플리케이션이 사용하게 될 포트(3000)를 컨테이너에서 열어줍니다.

- **`CMD ["npm", "start"]`**:  
  컨테이너가 시작되면 `npm start` 명령어로 애플리케이션을 실행하라는 의미입니다.

### 2. Docker 빌드 및 실행
Dockerfile을 준비한 후, 이미지를 빌드하고 실행해보는 단계입니다.
#### 2.1 이미지 빌드 명령어
```bash
docker build -t node-app:initial -f Dockerfile .
```
이 명령어는 Docker 이미지를 빌드하는 명령입니다.

- `docker build`: Docker 이미지를 빌드하는 기본 명령어입니다.
- `-t node-app:initial`: 빌드된 이미지를 `node-app:initial`이라는 이름과 태그로 저장하라는 의미입니다.
  - `node-app`: 이미지 이름
  - `initial`: 태그 이름 (버전 같은 역할)
- `-f Dockerfile`: 사용할 Dockerfile을 명시합니다. 여기서는 기본 Dockerfile을 사용합니다.
- `.`: 마지막으로 빌드 컨텍스트를 나타냅니다. 현재 디렉토리(.)에 있는 모든 파일이 빌드 과정에서 Docker로 전달됩니다.

빌드가 완료되면 Docker 이미지가 생성되고, 이 이미지를 기반으로 컨테이너를 실행할 수 있습니다.

#### 2.2 컨테이너 실행 명령어
```bash
docker run -p 3000:3000 node-app:initial
```

- `docker run`: Docker 컨테이너를 실행하는 명령어입니다.
- `-p 3000:3000`: 호스트 머신의 3000번 포트와 컨테이너의 3000번 포트를 연결하는 설정입니다. 애플리케이션이 컨테이너 내부에서 3000번 포트로 실행되기 때문에, 외부에서 접근하려면 이 설정이 필요합니다.
- `node-app:initial`: 실행할 이미지의 이름과 태그입니다.

이제 애플리케이션이 실행되고, 브라우저에서 [http://localhost:3000](http://localhost:3000)에 접속하면 컨테이너 내부에서 돌아가는 애플리케이션에 접근할 수 있습니다.

### 3. 최적화 Dockerfile 빌드

#### 3.1 최적화 Dockerfile 
최적화를 통해 이미지를 줄이는 과정을 진행합니다. 여기서는 Alpine 기반 Node.js 이미지를 사용해 이미지 크기를 줄입니다.
```dockerfile
FROM node:16-alpine

WORKDIR /usr/src/app

COPY app/package*.json ./

RUN npm install --production

COPY app/ .

EXPOSE 3000

CMD ["npm", "start"]
```
- `FROM node:16-alpine`: `alpine`은 경량화된 Linux 배포판입니다. 이 이미지를 사용하면 Docker 이미지 크기를 크게 줄일 수 있습니다.
- `npm install --production`: `--production` 옵션은 개발 의존성은 제외하고, 프로덕션 환경에서 필요한 패키지만 설치합니다.

#### 3.2 .dockerignore 파일 작성
```dockerfile
node_modules
npm-debug.log
Dockerfile*
.dockerignore
.git
```
- **`node_modules`**:  
  Node.js 애플리케이션에서 사용하는 의존성 패키지들이 저장되는 디렉토리입니다. 이 디렉토리는 이미지 빌드에 불필요하며, 최종 이미지를 경량화하기 위해 제외합니다.

- **`npm-debug.log`**:  
  NPM이 실행 중에 발생한 오류를 기록하는 로그 파일입니다. 디버깅에만 사용되며, 최종 이미지에 포함할 필요가 없습니다.

- **`Dockerfile*`**:  
  Dockerfile의 기본 파일 또는 그에 관련된 모든 파일을 제외합니다. Docker 이미지를 빌드할 때 필요한 설정 파일이므로, 빌드 과정에서 사용되도록 남겨두어야 합니다.

- **`.dockerignore`**:  
  Docker 빌드 과정에서 제외할 파일이나 디렉토리를 명시하는 파일입니다. 불필요한 파일이 이미지에 포함되지 않도록 관리합니다.

- **`.git`**:  
  Git 버전 관리 시스템에서 사용하는 메타데이터와 히스토리를 저장하는 디렉토리입니다. 최종 이미지에 포함할 필요가 없으므로 제외합니다.

#### 3.3 빌드 및 실행 명령어
```bash
docker build -t node-app:optimized -f Dockerfile.optimized .
docker run -p 3000:3000 node-app:optimized
```

## 확인 🔍
### 1. 초기 이미지 빌드
첫 번째로 node:16 이미지를 기반으로 애플리케이션을 컨테이너화하였습니다. 이 과정에서는 추가적인 최적화 없이 이미지를 생성하였으며, 결과적으로 이미지 크기는 약 916MB 가 나왔습니다.
```bash
docker build -t node-app:initial -f Dockerfile .
docker images  # 용량 확인
```
![image](https://github.com/user-attachments/assets/64a69b12-eb1a-4b43-973c-46cf60090d76)

### 2. 최적화 이미지 빌드
node:16-alpine과 같은 경량 이미지를 사용하고, 개발 환경에서만 필요한 패키지들을 제외함으로써 최적화를 적용했습니다. 최적화 후 이미지 크기는 124MB로 줄어들었습니다.
```bash
docker build -t node-app:optimized -f Dockerfile.optimized .
docker images  # 용량 비교
```
![image](https://github.com/user-attachments/assets/29388b4b-e113-4e6b-84d8-8cf28b7af9d3)


### 3. 성능 차이 확인
최적화 전과 후의 이미지 용량을 비교했을 때, 알파인 기반 이미지를 사용했을 때 빌드 시간 및 네트워크 전송 속도가 현저히 개선되었습니다.

## 결론 ✨
이 프로젝트는 Docker 이미지를 최적화하는 다양한 방법을 실습해보는 데 중점을 두었습니다. 주요 성과는 다음과 같습니다:

- **이미지 크기 감소**: `node:16` 이미지에서 `node:16-alpine`으로 변경하여 약 80% 이상의 이미지 용량을 줄일 수 있었습니다.
- **빠른 배포**: 경량화된 이미지를 사용하므로, 네트워크 전송 속도와 배포 시간이 단축되었습니다.
- **효율적인 자원 사용**: 불필요한 파일을 `.dockerignore`에 추가하고, 프로덕션 환경에 맞게 `npm install --production` 옵션을 사용하여 최적화했습니다.

이를 통해 **효율적인 Docker 이미지 관리의 중요성**을 깨닫게 되었으며, 실제 프로젝트에 적용할 수 있는 **실질적인 최적화 방법**을 배웠습니다.
