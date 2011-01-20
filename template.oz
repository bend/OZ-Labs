/*-------------------------------------------------------------------------
 *
 * This is a template for receiving arguments from the command line.
 *
 * Compile with
 *     ozc -x template.oz
 *
 * Examples of execution
 *    ./template --help
 *    ./template -h
 *    ./template --pub mypub
 *    ./template -p mybar --beers 20
 *
 *-------------------------------------------------------------------------
 */

functor
import
   Application
   Property
   System

define
  
   %% Default values
   PUB      = 'Kings Head'
   BEERS    = 10  

   %% For feedback
   Say      = System.showInfo

   Args

in

   %% Possible arguments
   Args = try
             {Application.getArgs
                 record(
                        pub(single char:&p type:atom default:PUB)
                        beers(single char:&b type:int default:BEERS) 
                        help(single char:&h default:false)
                       )}
          catch _ then
             {Say 'Unrecognised arguments'}
             optRec(help:true)
          end
   
   %% Help message
   if Args.help then
      {Say "Usage: "#{Property.get 'application.url'}#" [option]"}
      {Say "Options:"}
      {Say "  -p, --pub TEXT\tName of the pub (default "#PUB#")"}
      {Say "  -b, --beers INT\tNumber of beers to drink (default: "#BEERS#")"}
      {Say "  -h, --help\t\tThis help"}
      {Application.exit 0}
   end

   {Say "We will go "#Args.pub#" and have "#Args.beers#" beers"}
   {Application.exit 0}
end

