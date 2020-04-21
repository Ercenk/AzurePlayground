using System;
using System.Linq;
using Microsoft.Azure.Management.Compute.Fluent;
using Microsoft.Azure.Management.Compute.Fluent.Models;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Extensions.Configuration;

namespace PartnerUsageAttribution
{
    class Program
    {
        static void Main(string[] args)
        {
            var configurationBuilder = new ConfigurationBuilder();
            configurationBuilder.AddUserSecrets<Program>();

            var configuration = configurationBuilder.Build();


            var credentials = SdkContext.AzureCredentialsFactory
                                .FromServicePrincipal(configuration["appId"],
                                configuration["password"],
                                configuration["tenant"],
                                AzureEnvironment.AzureGlobalCloud);
    
        
            var azure = Azure
                .Configure()
                // just set the product name, version is not required
                .WithUserAgent("pid-1af03e76-4403-4298-a570-2d65516a794b", "")
                .Authenticate(credentials)
                .WithSubscription(configuration["subscriptionId"]);


            var vms = azure.VirtualMachines.List();

            var linuxVM = azure.VirtualMachines.Define("ErcLinuxVm")
                .WithRegion(Region.USEast2)
                .WithNewResourceGroup("ErcCreateWithCode")
                .WithNewPrimaryNetwork("10.0.0.0/28")
                .WithPrimaryPrivateIPAddressDynamic()
                .WithNewPrimaryPublicIPAddress("erctstlinux1")
                .WithPopularLinuxImage(KnownLinuxVirtualMachineImage.UbuntuServer16_04_Lts)
                .WithRootUsername("ercenk")
                .WithRootPassword("Main@nyDelic10usVeggies")
                .WithUnmanagedDisks()
                .WithSize(VirtualMachineSizeTypes.StandardD3V2)
                .Create();


            Console.WriteLine(vms.Count());
        }
    }
}
