# VS Code Online

```code-server``` is [VS Code](https://github.com/Microsoft/vscode) running on a remote server, accessible through the browser.

I saw this Idea in a [Christiaan Hees](https://medium.com/google-cloud/how-to-run-visual-studio-code-in-google-cloud-shell-354d125d5748) post and made some adjustments to get the procedure done faster.

## Usage

This script runs the latest version of [code-server (VS Code)](https://github.com/cdr/code-server) with just one command.

This script needs the following packages:

- [jq](https://stedolan.github.io/jq/)

### via curl
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/renanteixeira/vscodegcs/master/codeserver.sh)"
```

### via wget
```bash
sh -c "$(wget https://raw.githubusercontent.com/renanteixeira/vscodegcs/master/codeserver.sh -O -)"
```

## After running

After executing the above command, you will see the information below.


```bash
info  Server listening on http://localhost:8080
info    - Password is ## A random password is generated.
info      - To use your own password, set the PASSWORD environment variable
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

### That’s it, now you have an IDE running in your browser!
![VS Code Online](https://miro.medium.com/max/1996/1*BVCoNecwFAR7vcmaJ9a2gA.png)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)