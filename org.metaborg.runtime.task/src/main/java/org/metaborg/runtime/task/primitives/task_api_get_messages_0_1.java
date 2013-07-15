package org.metaborg.runtime.task.primitives;

import org.metaborg.runtime.task.ITaskEngine;
import org.metaborg.runtime.task.TaskManager;
import org.spoofax.interpreter.core.IContext;
import org.spoofax.interpreter.core.InterpreterException;
import org.spoofax.interpreter.library.AbstractPrimitive;
import org.spoofax.interpreter.stratego.Strategy;
import org.spoofax.interpreter.terms.IStrategoList;
import org.spoofax.interpreter.terms.IStrategoString;
import org.spoofax.interpreter.terms.IStrategoTerm;
import org.spoofax.interpreter.terms.ITermFactory;

public class task_api_get_messages_0_1 extends AbstractPrimitive {
	public static task_api_get_messages_0_1 instance = new task_api_get_messages_0_1();

	public task_api_get_messages_0_1() {
		super("task_api_get_messages", 0, 1);
	}
	
	@Override
	public boolean call(IContext env, Strategy[] svars, IStrategoTerm[] tvars)
		throws InterpreterException {
		final ITermFactory factory = env.getFactory();
		final ITaskEngine taskEngine = TaskManager.getInstance().getCurrent();
		final IStrategoString partition = (IStrategoString)tvars[0];
		IStrategoList messages = factory.makeList();
		for(IStrategoTerm taskID : taskEngine.getInPartition(partition)) {
			IStrategoTerm message = taskEngine.getTask(taskID).message();
			if(message != null)
				messages = factory.makeListCons(message, messages);
		}
		env.setCurrent(messages);
		return true;
	}
}
