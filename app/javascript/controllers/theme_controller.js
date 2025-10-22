// frozen_string_literal: true

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  connect() {
    this.initializeTheme()
  }

  toggle() {
    const currentTheme = this.getCurrentTheme()
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark'
    this.setTheme(newTheme)
  }

  initializeTheme() {
    const savedTheme = localStorage.getItem('theme')
    const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
    const theme = savedTheme || 'system'
    
    this.setTheme(theme)
  }

  setTheme(theme) {
    const html = document.documentElement
    
    if (theme === 'system') {
      html.setAttribute('data-theme', 'system')
      localStorage.setItem('theme', 'system')
    } else {
      html.setAttribute('data-theme', theme)
      localStorage.setItem('theme', theme)
    }
    
    this.updateIcon(theme)
  }

  getCurrentTheme() {
    const savedTheme = localStorage.getItem('theme')
    if (savedTheme === 'system') {
      return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
    }
    return savedTheme || 'light'
  }

  updateIcon(theme) {
    const icon = this.element.querySelector('.theme-icon')
    if (icon) {
      icon.textContent = theme === 'dark' ? '☀️' : '🌙'
    }
  }
}





