using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(MobilDataBase.Startup))]
namespace MobilDataBase
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
