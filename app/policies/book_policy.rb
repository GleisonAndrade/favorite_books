class BookPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.profile.reader?
        Book.actives
      elsif user.profile.librarian?
        Book.actives
      elsif user.profile.admin?
        Book.all
      end
    end
  end

  def index?
    true
  end

  def show?
    record.status.active? || user.profile.admin?
  end

  def create?
    user.profile.admin? || user.profile.librarian?
  end

  def new?
    create?
  end

  def update?
    !record.new_record? && record.active? && (user.profile.librarian? || user.profile.admin?)
  end

  def edit?
    update?
  end

  def destroy?
    !record.new_record? && record.status.active? && (user.profile.admin? || user.profile.librarian?)
  end

  def favorite?
    record.status.active? && user.profile.reader?
  end

end
