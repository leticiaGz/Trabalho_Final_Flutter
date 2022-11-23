class UrlApi {
 String url= " ";

  saveUrl(String urlQr){
    url = urlQr;
    print("cheguei aqui"+url);
  }

  getUrl(){
    print("chamei"+url);
    return url;
  }
}