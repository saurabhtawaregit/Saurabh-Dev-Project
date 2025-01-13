import { LightningElement, api, track } from 'lwc';

export default class DynamicProgressPath extends LightningElement {
    @api currentStep;
    @api stepsString;

    @track steps = [];
    @track currentStepValue;

    connectedCallback() {
        this.initializeSteps();
        this.setCurrentStepValue();
    }

    initializeSteps() {
        this.steps = this.parseSteps(this.stepsString);
    }

    parseSteps(stepsString) {
        return stepsString.split(',').map((step, index) => ({
            label: step.trim(),
            value: `step-${index + 1}`
        }));
    }

    setCurrentStepValue() {
        this.currentStepValue = this.getStepValue(this.currentStep);
    }

    getStepValue(currentStepLabel) {
        const step = this.steps.find(step => step.label === currentStepLabel);
        return step ? step.value : '';
    }
}