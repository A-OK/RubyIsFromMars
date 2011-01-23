import org.jruby.embed.ScriptingContainer
import org.jruby.javasupport.JavaEmbedUtils
import org.jruby.runtime.builtin.IRubyObject
import org.jruby.embed.PathType

import org.jruby.embed.ScriptingContainer

object Mars extends Application {

val container = new ScriptingContainer()
val receiver = container.runScriptlet(PathType.CLASSPATH,
               "mars.rb")
val arg = 17.0

val result = container.callMethod(receiver, "mars_age", arg,
             classOf[java.lang.Double])

System.out.println(result)

}
