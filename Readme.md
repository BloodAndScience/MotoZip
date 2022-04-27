# MotoZip

> changes made by Yuriy

## Links


-  [**IC** Bounty link](https://icdevs.org/bounties/2022/02/21/Zip-Encoder-Decoder.html)
- [Pako Zip](https://github.com/nodeca/pako)

Our Motoko ZIP project based on the **IC** bounty.

## Roadmap

- [x] Set up project
- [ ] Make Unit tests
- [ ] Pass unity test
- [ ] Get the money


## Interface 

``` js
compress(Pipelinify.ProcessRequest) -> Pipelinify.ProcessResponse; //sets up a compress process

compress_process(Pipelinify.StepRequest) -> Result<ProcessResponse,ProcessError>; //executes a step

decompress(Pipelinify.ProcessRequest) -> Pipelinify.ProcessResponse; //sets up a decompress process

decompress_process(Pipelinify.StepRequest) -> Result<ProcessResponse,ProcessError>; //executes a step

compress_result(Pipelinify.ProcessingStatusRequest) -> Buffer<Buffer.Buffer<nat8>>, metadata: ZIP};

decompress_result(Pipelinify.ProcessingStatusRequest) -> Buffer<Buffer.Buffer<nat8>>;

clear_cache(?Pipelinify.ProcessingStatusRequest) -> bool; //clean out any pipelinify cache for a status request, or the entire cache if null

type ZIP = {
    //see the spec and define this type
}
```

