## README
twitterを検索して、キーワードに一致するツイートをchatworkにつぶやきます

## setting

```
cp .env_sample .env
rake db:migrate
rails runner "Batches::TwSearch.execute('search word')"
```

