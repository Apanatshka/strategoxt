package org.metaborg.runtime.task.evaluation;

import java.util.Set;

import org.metaborg.runtime.task.ITaskEngine;
import org.metaborg.runtime.task.Task;
import org.metaborg.runtime.task.TaskType;
import org.spoofax.interpreter.core.IContext;
import org.spoofax.interpreter.stratego.Strategy;
import org.spoofax.interpreter.terms.IStrategoList;
import org.spoofax.interpreter.terms.IStrategoTerm;
import org.spoofax.interpreter.terms.ITermFactory;

/**
 * Interface for evaluating individual tasks.
 */
public interface ITaskEvaluator {
	/**
	 * Returns adjusted dependencies.
	 */
	public abstract IStrategoList adjustDependencies(IStrategoList dependencies, ITermFactory factory);

	/**
	 * Creates a task.
	 */
	public abstract Task create(IStrategoTerm instruction, IStrategoList dependencies, TaskType type,
		boolean shortCircuit);

	/**
	 * Queues task from given set of scheduled tasks.
	 */
	public abstract void queue(ITaskEngine taskEngine, ITaskEvaluationQueue evaluationQueue,
		Set<IStrategoTerm> scheduled);

	/**
	 * Evaluates given task.
	 */
	public abstract void evaluate(IStrategoTerm taskID, Task task, ITaskEngine taskEngine,
		ITaskEvaluationQueue evaluationQueue, IContext context, Strategy collect, Strategy insert, Strategy perform);

	/**
	 * Evaluates given cyclic task.
	 */
	public abstract void evaluateCyclic(IStrategoTerm taskID, Task task, ITaskEngine taskEngine,
		ITaskEvaluationQueue evaluationQueue, IContext context, Strategy collect, Strategy insert, Strategy perform);

	/**
	 * Returns the task identifier of the task that is currently being evaluated.
	 */
	public abstract IStrategoTerm current();

	/**
	 * Delays the current executing task.
	 */
	public abstract void delay();

	/**
	 * Resets the task evaluator to its initial state.
	 */
	public abstract void reset();
}
