import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "list", "input"]

  connect() {
    console.log("Todo controller connected")
  }

  // Handle form submission with Turbo
  submitForm(event) {
    // Let Turbo handle the form submission
    // This method can be used for additional client-side validation if needed
  }

  // Handle todo toggle with animation
  toggleTodo(event) {
    const todoItem = event.currentTarget.closest('.todo-item')
    const toggleBtn = event.currentTarget
    
    // Add loading state
    toggleBtn.style.opacity = '0.5'
    toggleBtn.style.pointerEvents = 'none'
    
    // Add a subtle animation
    todoItem.style.transition = 'all 0.3s ease'
    
    // The actual toggle will be handled by the server response via Turbo
  }

  // Handle todo deletion with confirmation
  deleteTodo(event) {
    if (!confirm('Are you sure you want to delete this todo?')) {
      event.preventDefault()
    }
  }

  // Clear form after successful submission
  clearForm() {
    if (this.hasFormTarget) {
      this.formTarget.reset()
    }
  }

  // Focus on the title input when the form is displayed
  focusTitleInput() {
    if (this.hasInputTarget) {
      this.inputTarget.focus()
    }
  }
}



