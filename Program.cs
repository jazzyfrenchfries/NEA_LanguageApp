using NEA.Components;
using Blazored.Modal;
using Microsoft.Extensions.Options;
using System.Security.Principal;
using Blazored.LocalStorage;
var builder = WebApplication.CreateBuilder(args);

Console.WriteLine("App is running as: " + WindowsIdentity.GetCurrent().Name);
// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();
builder.Services.AddServerSideBlazor();
builder.Services.AddBlazoredModal();
builder.Services.AddScoped<DatabaseService>();
builder.Services.AddScoped<UserState>();
builder.Services.AddBlazoredLocalStorage();
var app = builder.Build();


// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseAntiforgery();
app.MapStaticAssets();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
