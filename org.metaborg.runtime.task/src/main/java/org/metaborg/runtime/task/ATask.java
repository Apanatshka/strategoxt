package org.metaborg.runtime.task;

import org.spoofax.interpreter.terms.IStrategoList;
import org.spoofax.interpreter.terms.IStrategoTerm;

public abstract class ATask implements ITask {
	private final IStrategoTerm instruction;
	private final IStrategoList initialDependencies;
	// TODO: move these to task (type) definition, this is wasting space.
	private final TaskType type;
	private final boolean shortCircuit;

	private IStrategoTerm instructionOverride = null;
	private TaskStatus status = TaskStatus.Unknown;
	private IStrategoTerm message;
	private long time = -1;
	private short evaluations = 0;

	public ATask(IStrategoTerm instruction, IStrategoList initialDependencies, TaskType type, boolean shortCircuit) {
		this.instruction = instruction;
		this.initialDependencies = initialDependencies;

		this.type = type;
		this.shortCircuit = shortCircuit;
	}

	public ATask(ATask task) {
		this.instruction = task.instruction;
		this.initialDependencies = task.initialDependencies;

		this.type = task.type;
		this.shortCircuit = task.shortCircuit;

		this.instructionOverride = task.instructionOverride;
		this.status = task.status;
		this.message = task.message;
		this.time = task.time;
		this.evaluations = task.evaluations;
	}

	@Override
	public IStrategoTerm instruction() {
		if(instructionOverride == null)
			return instruction;
		return instructionOverride;
	}

	@Override
	public void overrideInstruction(IStrategoTerm newInstruction) {
		instructionOverride = newInstruction;
	}

	@Override
	public IStrategoTerm instructionOverride() {
		return instructionOverride;
	}

	@Override
	public IStrategoTerm initialInstruction() {
		return instruction;
	}

	@Override
	public void clearInstructionOverride() {
		instructionOverride = null;
	}


	@Override
	public IStrategoList initialDependencies() {
		return initialDependencies;
	}


	@Override
	public TaskType type() {
		return type;
	}


	@Override
	public boolean shortCircuit() {
		return shortCircuit;
	}


	@Override
	public TaskStatus status() {
		return status;
	}

	@Override
	public void setStatus(TaskStatus status) {
		this.status = status;
	}

	@Override
	public boolean failed() {
		return status == TaskStatus.Fail || status == TaskStatus.DependencyFail;
	}

	@Override
	public void setFailed() {
		status = TaskStatus.Fail;
	}

	@Override
	public boolean dependencyFailed() {
		return status == TaskStatus.DependencyFail;
	}

	@Override
	public void setDependencyFailed() {
		status = TaskStatus.DependencyFail;
	}

	@Override
	public boolean solved() {
		return status != TaskStatus.Unknown;
	}

	@Override
	public void unsolve() {
		clearResults();
		status = TaskStatus.Unknown;
	}


	@Override
	public IStrategoTerm message() {
		return message;
	}

	@Override
	public void setMessage(IStrategoTerm message) {
		this.message = message;
	}

	@Override
	public void clearMessage() {
		message = null;
	}


	@Override
	public long time() {
		return time;
	}

	@Override
	public void setTime(long time) {
		this.time = time;
	}

	@Override
	public void addTime(long time) {
		this.time += time;
	}

	@Override
	public void clearTime() {
		time = -1;
	}


	@Override
	public short evaluations() {
		return evaluations;
	}

	@Override
	public void setEvaluations(short evaluations) {
		this.evaluations = evaluations;
	}

	@Override
	public void addEvaluation() {
		++evaluations;
	}

	@Override
	public void clearEvaluations() {
		evaluations = 0;
	}


	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((initialDependencies == null) ? 0 : initialDependencies.hashCode());
		result = prime * result + ((instruction == null) ? 0 : instruction.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if(this == obj)
			return true;
		if(obj == null)
			return false;
		if(getClass() != obj.getClass())
			return false;
		ATask other = (ATask) obj;
		if(initialDependencies == null) {
			if(other.initialDependencies != null)
				return false;
		} else if(!initialDependencies.equals(other.initialDependencies))
			return false;
		if(instruction == null) {
			if(other.instruction != null)
				return false;
		} else if(!instruction.equals(other.instruction))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Task [instruction=" + instruction + ", type=" + type + ", results=" + results()
			+ ", status=" + status + ", message=" + message + ", time=" + time + ", evaluations=" + evaluations + "]";
	}
}