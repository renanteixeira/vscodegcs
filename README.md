# VS Code Online

```code-server``` is [VS Code](https://github.com/Microsoft/vscode) running on a remote server, accessible through the browser.

I saw this Idea in a [Christiaan Hees](https://medium.com/google-cloud/how-to-run-visual-studio-code-in-google-cloud-shell-354d125d5748) post and made some adjustments to get the procedure done faster.

## Usage

This script runs the latest version of [code-server (VS Code)](https://github.com/cdr/code-server) with just one command.

## via curl
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/renanteixeira/vscodegcs/master/codeserver.sh)"
```

## via wget
```bash
sh -c "$(wget https://raw.githubusercontent.com/renanteixeira/vscodegcs/master/codeserver.sh -O -)"
```

## Running

> First run, you will have to select the settings.
This screen will create a configuration file in "~/ .config/code-server/config.yaml"

![bindAddr](https://user-images.githubusercontent.com/6026211/89003094-378bd780-d2d5-11ea-90c3-ac9e38efcc8a.png)
![authMode](https://user-images.githubusercontent.com/6026211/89003167-66a24900-d2d5-11ea-9615-425d6b93652d.png)

> New executions, you will be asked if you want to use the settings already saved or if you want to create new ones.

![config](https://user-images.githubusercontent.com/6026211/89003709-e381f280-d2d6-11ea-8e9a-570cc3b963c0.png)

```bash
password: (Random string or Custom Password)

info  Using config file ~/.config/code-server/config.yaml
info  Using user-data-dir ~/.local/share/code-server
info  code-server 3.4.1 48f7c2724827e526eeaa6c2c151c520f48a61259
info  HTTP server listening on http://127.0.0.1:8080
info      - Using password from ~/.config/code-server/config.yaml
info      - To disable use `--auth none`
info    - Not serving HTTPS
```

If you are using the local machine, simply access the Localhost address.

```bash
http://localhost:8080
```
In [Google Cloud Shell](https://cloud.google.com/shell/) click the Web Preview icon and select Preview on port 8080.

![GCS Web Preview](https://miro.medium.com/max/636/1*tcyI0xwhSF7Wn1upszdhDA.png)

I recommend using [Boost Mode in Cloud Shell](https://cloud.google.com/shell/docs/how-cloud-shell-works#boost_mode) before running

![Boost Mode](https://miro.medium.com/max/2574/1*D8J4okWRgFRnxo7MhbHGPg.png)

## That’s it, now you have an IDE running in your browser!
![VS Code Online](https://miro.medium.com/max/1996/1*BVCoNecwFAR7vcmaJ9a2gA.png)

## FAQ Code Server
See [CDR FAQ](https://github.com/cdr/code-server/blob/master/doc/guide.md).

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)