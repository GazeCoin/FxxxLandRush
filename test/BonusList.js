var bonusListOutput={
  "contracts" : 
  {
    "BonusList.sol:BonusList" : 
    {
      "abi" : "[{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"address\"}],\"name\":\"operators\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"accounts\",\"type\":\"address[]\"}],\"name\":\"remove\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"address\"}],\"name\":\"bonusList\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"acceptOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnershipImmediately\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"account\",\"type\":\"address\"}],\"name\":\"isInBonusList\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_operator\",\"type\":\"address\"}],\"name\":\"addOperator\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_operator\",\"type\":\"address\"}],\"name\":\"removeOperator\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"accounts\",\"type\":\"address[]\"}],\"name\":\"add\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"newOwner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"status\",\"type\":\"bool\"}],\"name\":\"AccountListed\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"_operator\",\"type\":\"address\"}],\"name\":\"OperatorAdded\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"_operator\",\"type\":\"address\"}],\"name\":\"OperatorRemoved\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"}]",
      "bin" : "608060405234801561001057600080fd5b5061002333640100000000610028810204565b61005f565b61003a8164010000000061003d810204565b50565b60008054600160a060020a031916600160a060020a0392909216919091179055565b6108708061006e6000396000f3006080604052600436106100b95763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166313e7c9d881146100be5780635e4ba17c146100f357806376fbc07e1461014a57806379ba50971461016b5780637e71fb09146101805780638da5cb5b146101a15780639773252a146101d25780639870d7fe146101f3578063ac8a584a14610214578063c4c1c94f14610235578063d4ee1d901461028a578063f2fde38b1461029f575b600080fd5b3480156100ca57600080fd5b506100df600160a060020a03600435166102c0565b604080519115158252519081900360200190f35b3480156100ff57600080fd5b5060408051602060048035808201358381028086018501909652808552610148953695939460249493850192918291850190849080828437509497506102d59650505050505050565b005b34801561015657600080fd5b506100df600160a060020a036004351661042f565b34801561017757600080fd5b50610148610444565b34801561018c57600080fd5b50610148600160a060020a03600435166104cc565b3480156101ad57600080fd5b506101b661054b565b60408051600160a060020a039092168252519081900360200190f35b3480156101de57600080fd5b506100df600160a060020a036004351661055a565b3480156101ff57600080fd5b50610148600160a060020a0360043516610560565b34801561022057600080fd5b50610148600160a060020a03600435166105f8565b34801561024157600080fd5b50604080516020600480358082013583810280860185019096528085526101489536959394602494938501929182918501908490808284375094975061068e9650505050505050565b34801561029657600080fd5b506101b66107ef565b3480156102ab57600080fd5b50610148600160a060020a03600435166107fe565b60026020526000908152604090205460ff1681565b3360009081526002602052604081205460ff16806102fd5750600054600160a060020a031633145b151561030857600080fd5b8151151561031557600080fd5b5060005b815181101561042b57815160009083908390811061033357fe5b60209081029091010151600160a060020a0316141561035157600080fd5b60036000838381518110151561036357fe5b6020908102909101810151600160a060020a031682528101919091526040016000205460ff1615610423576003600083838151811015156103a057fe5b6020908102909101810151600160a060020a03168252810191909152604001600020805460ff1916905581518290829081106103d857fe5b602090810290910181015160408051600081529051600160a060020a03909216927f0426e02a5e8dbdd68720eb6c318dd8e3128b8c5597fdf2f72335e52f217a1b5b92918290030190a25b600101610319565b5050565b60036020526000908152604090205460ff1681565b600154600160a060020a0316331461045b57600080fd5b60015460008054604051600160a060020a0393841693909116917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e091a3600180546000805473ffffffffffffffffffffffffffffffffffffffff19908116600160a060020a03841617909155169055565b600054600160a060020a031633146104e357600080fd5b60008054604051600160a060020a03808516939216917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e091a36000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0392909216919091179055565b600054600160a060020a031681565b50600190565b600054600160a060020a0316331461057757600080fd5b600160a060020a03811660009081526002602052604090205460ff161561059d57600080fd5b600160a060020a038116600081815260026020908152604091829020805460ff19166001179055815192835290517fac6fa858e9350a46cec16539926e0fde25b7629f84b5a72bffaae4df888ae86d9281900390910190a150565b600054600160a060020a0316331461060f57600080fd5b600160a060020a03811660009081526002602052604090205460ff16151561063657600080fd5b600160a060020a038116600081815260026020908152604091829020805460ff19169055815192835290517f80c0b871b97b595b16a7741c1b06fed0c6f6f558639f18ccbce50724325dc40d9281900390910190a150565b3360009081526002602052604081205460ff16806106b65750600054600160a060020a031633145b15156106c157600080fd5b815115156106ce57600080fd5b5060005b815181101561042b5781516000908390839081106106ec57fe5b60209081029091010151600160a060020a0316141561070a57600080fd5b60036000838381518110151561071c57fe5b6020908102909101810151600160a060020a031682528101919091526040016000205460ff1615156107e757600160036000848481518110151561075c57fe5b602090810291909101810151600160a060020a03168252810191909152604001600020805460ff1916911515919091179055815182908290811061079c57fe5b602090810290910181015160408051600181529051600160a060020a03909216927f0426e02a5e8dbdd68720eb6c318dd8e3128b8c5597fdf2f72335e52f217a1b5b92918290030190a25b6001016106d2565b600154600160a060020a031681565b600054600160a060020a0316331461081557600080fd5b6001805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a03929092169190911790555600a165627a7a72305820b541fa91c046f106892d816ef46ce2f0e1422bbb3ca47eff36c652ed11f9c5180029"
    },
    "BonusListInterface.sol:BonusListInterface" : 
    {
      "abi" : "[{\"constant\":true,\"inputs\":[{\"name\":\"account\",\"type\":\"address\"}],\"name\":\"isInBonusList\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"}]",
      "bin" : ""
    },
    "Operated.sol:Operated" : 
    {
      "abi" : "[{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"address\"}],\"name\":\"operators\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"acceptOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnershipImmediately\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_operator\",\"type\":\"address\"}],\"name\":\"addOperator\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_operator\",\"type\":\"address\"}],\"name\":\"removeOperator\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"newOwner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"_operator\",\"type\":\"address\"}],\"name\":\"OperatorAdded\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"_operator\",\"type\":\"address\"}],\"name\":\"OperatorRemoved\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"}]",
      "bin" : "608060405234801561001057600080fd5b50610482806100206000396000f30060806040526004361061008d5763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166313e7c9d8811461009257806379ba5097146100c75780637e71fb09146100de5780638da5cb5b146100ff5780639870d7fe14610130578063ac8a584a14610151578063d4ee1d9014610172578063f2fde38b14610187575b600080fd5b34801561009e57600080fd5b506100b3600160a060020a03600435166101a8565b604080519115158252519081900360200190f35b3480156100d357600080fd5b506100dc6101bd565b005b3480156100ea57600080fd5b506100dc600160a060020a0360043516610245565b34801561010b57600080fd5b506101146102c4565b60408051600160a060020a039092168252519081900360200190f35b34801561013c57600080fd5b506100dc600160a060020a03600435166102d3565b34801561015d57600080fd5b506100dc600160a060020a036004351661036b565b34801561017e57600080fd5b50610114610401565b34801561019357600080fd5b506100dc600160a060020a0360043516610410565b60026020526000908152604090205460ff1681565b600154600160a060020a031633146101d457600080fd5b60015460008054604051600160a060020a0393841693909116917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e091a3600180546000805473ffffffffffffffffffffffffffffffffffffffff19908116600160a060020a03841617909155169055565b600054600160a060020a0316331461025c57600080fd5b60008054604051600160a060020a03808516939216917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e091a36000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0392909216919091179055565b600054600160a060020a031681565b600054600160a060020a031633146102ea57600080fd5b600160a060020a03811660009081526002602052604090205460ff161561031057600080fd5b600160a060020a038116600081815260026020908152604091829020805460ff19166001179055815192835290517fac6fa858e9350a46cec16539926e0fde25b7629f84b5a72bffaae4df888ae86d9281900390910190a150565b600054600160a060020a0316331461038257600080fd5b600160a060020a03811660009081526002602052604090205460ff1615156103a957600080fd5b600160a060020a038116600081815260026020908152604091829020805460ff19169055815192835290517f80c0b871b97b595b16a7741c1b06fed0c6f6f558639f18ccbce50724325dc40d9281900390910190a150565b600154600160a060020a031681565b600054600160a060020a0316331461042757600080fd5b6001805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a03929092169190911790555600a165627a7a72305820d37be220323f8108c8fb48e26c9424fcae39079e730c4a399053dbdec77d64cb0029"
    },
    "Owned.sol:Owned" : 
    {
      "abi" : "[{\"constant\":false,\"inputs\":[],\"name\":\"acceptOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnershipImmediately\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"newOwner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"}]",
      "bin" : "608060405234801561001057600080fd5b506102a7806100206000396000f30060806040526004361061006c5763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166379ba509781146100715780637e71fb09146100885780638da5cb5b146100a9578063d4ee1d90146100da578063f2fde38b146100ef575b600080fd5b34801561007d57600080fd5b50610086610110565b005b34801561009457600080fd5b50610086600160a060020a0360043516610198565b3480156100b557600080fd5b506100be610217565b60408051600160a060020a039092168252519081900360200190f35b3480156100e657600080fd5b506100be610226565b3480156100fb57600080fd5b50610086600160a060020a0360043516610235565b600154600160a060020a0316331461012757600080fd5b60015460008054604051600160a060020a0393841693909116917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e091a3600180546000805473ffffffffffffffffffffffffffffffffffffffff19908116600160a060020a03841617909155169055565b600054600160a060020a031633146101af57600080fd5b60008054604051600160a060020a03808516939216917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e091a36000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0392909216919091179055565b600054600160a060020a031681565b600154600160a060020a031681565b600054600160a060020a0316331461024c57600080fd5b6001805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a03929092169190911790555600a165627a7a72305820245d64f76f744e473cce0ad9a6c19166bb542ac94cd7d2f4de7a73899d28ffea0029"
    }
  },
  "version" : "0.4.25+commit.59dbf8f1.Darwin.appleclang"
};
