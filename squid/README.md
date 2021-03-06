#### References:

## Transparent Proxy
https://wiki.alpinelinux.org/wiki/Setting_up_Explicit_Squid_Proxy

## AWS  Blog
https://aws.amazon.com/blogs/security/how-to-add-dns-filtering-to-your-nat-instance-with-squid/

https://docs.amazonaws.cn/en_us/codebuild/latest/userguide/use-proxy-server.html

## Andreev Blog
https://blog.andreev.it/?p=6035

## Terraform Template
https://www.nearform.com/blog/building-a-transparent-proxy-in-aws-vpc-with-terraform-and-squid/

## Splice and peek
https://wiki.squid-cache.org/Features/SslPeekAndSplice

https://blog.microlinux.fr/squid-exceptions/

http://marek.helion.pl/install/squid.html

https://forum.netgate.com/topic/124581/solved-help-needed-bypass-squid-and-squidguard-for-itunes-applestore-android/10

https://www.spinics.net/lists/squid/msg87876.html

https://forum.netgate.com/topic/148642/bypass-squid-proxy-for-domain-name

## Bypass domains using IPtables
https://gist.github.com/elico/e0faadf0cc63942c5aaade808a87deef

## Git verbose
export GIT_CURL_VERBOSE=1\
export GIT_TRACE_PACKET=2\
git --version\
curl --version


# Error Faced
> ssh_exchange_identification: Connection reset by peer
```
https://docs.gitlab.com/ee/ssh/
```

> failed to export image: failed to set parent sha256:xxxxxxxxxxxxxxxx: unknown parent image ID

> ssh: connect to host gitlab.com port 22: Cannot assign requested address
```
Please make sure you have the correct access rights and the repository exists.
```

> Unable to Download using wget behind a proxy
