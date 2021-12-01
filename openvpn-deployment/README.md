# openvpn-deployment


## 00. multi-cpi openvpn 구성 
```
openvpn az-1 : 1 server + 1 client (1vm)
openvpn az-2 : 1 server + 1 client (1vm)
```

## 01. openvpn 정보 수정
> IaaS 사용할 영역 주석 해제 및 정보 수정
``` 
$ vi vars-az1.yml
$ vi vars-az2.yml
``` 

> deploy-vpn-az1.sh 및 deploy-vpn-az2.sh에서 IaaS용 yml 선언
``` 
$ vi deploy-vpn-az1.sh
$ vi deploy-vpn-az2.sh

ex) choose one..
-o operations/init-aws.yml \
-o operations/init-openstack.yml \
-o operations/init-vsphere.yml \

``` 

## 02. 인증서 생성
> 서버별로 실행하지 않고 최초 1회만 실행. <br>
주의 ::: 생성된 인증서를 복사하여 사용

``` 
$ source generate_ca.sh
$ ll creds
drwxrwxr-x 2 ubuntu ubuntu  4096 Jul 22 02:12 ./
drwxrwxr-x 4 ubuntu ubuntu  4096 Jul 21 01:47 ../
-rw-rw-r-- 1 ubuntu ubuntu 18098 Jul 14 04:22 vpn-server-az1.yml
-rw-rw-r-- 1 ubuntu ubuntu 18102 Jul 14 04:22 vpn-server-az2.yml
```

## 03. openvpn-az1 배포
> '02. 인증서 생성' 단계에서 생성된 인증서를 사용하여 배포. 
``` 
$ ./deploy-vpn-az1.sh
```

> ssh 접속 방법
``` 
$ bosh int creds/vpn-deploy-az1.yml --path /ssh/private_key > openvpn-az1.key 
$ chmod 600 openvpn-az1.key
$ ssh openvpn@<openvpn-az1-ip> -i openvpn-az1.key
```

## 04. openvpn-az2 배포
> '02. 인증서 생성' 단계에서 생성된 인증서를 사용하여 배포. 
``` 
$ ./deploy-vpn-az2.sh
```

> ssh 접속 방법
``` 
$ bosh int creds/vpn-deploy-az2.yml --path /ssh/private_key > openvpn-az2.key 
$ chmod 600 openvpn-az2.key
$ ssh openvpn@<openvpn-az2-ip> -i openvpn-az2.key
```

## 05. openvpn 연결 체크 
> 각 openvpn 서버/클라이언트의 연결 정보 확인 <br>
만약 네트워크 인터페이스에 tun0과 tun2가 있으면 상호간 연결 성공
```
$ ssh openvpn@<openvpn-az1-ip> -i openvpn-az1.key 
or 
$ ssh openvpn@<openvpn-az2-ip> -i openvpn-az2.key 

$ sudo su
$ ifconfig 
$ ping <remote_network_ip>
``` 

## 06. 정적 라우팅 추가 (optional)
> 클라이언트 터널을 사용하기 위해 정적 라우팅 추가 <br>
IaaS에서 지원하지 않는 경우 vm에서 아래 명령어를 통해 정적 라이팅을 설정
```
$ sudo ip route add <remote_network_cidr_block> via <lan_ip>
ex> sudo ip route add 20.0.20.0/24 via 10.0.10.10

$ ping <remote_network_ip>
```

## 참고 자료
openvpn-bosh-release: [https://github.com/dpb587/openvpn-bosh-release](https://github.com/dpb587/openvpn-bosh-release)<br>
