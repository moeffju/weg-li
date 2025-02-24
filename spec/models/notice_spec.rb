require 'spec_helper'

describe Notice do
  let(:notice) { Fabricate.build(:notice) }

  context "validation" do
    it "is valid" do
      expect(notice).to be_valid
      expect(notice.photos.first.filename.to_s).to eql('mercedes.jpg')
    end

    it "validates the date" do
      expect(notice).to be_valid
      notice.date = 2.minutes.from_now
      expect(notice).to_not be_valid
      notice.date = 2.months.ago
      expect(notice).to be_valid
      notice.date = 4.months.ago
      expect(notice).to_not be_valid
    end
  end

  context "wegli_email" do
    it "creates and reads the proper notice" do
      notice =  Fabricate.create(:notice)

      email_address = notice.wegli_email
      notice = Notice.from_email_address(email_address)
      expect(notice).to eql(notice)
    end
  end

  context "duplication" do
    it "duplicates a notice" do
      notice = Fabricate(:notice)
      expect {
        notice.duplicate!
      }.to change {
        Notice.count
      }.by(1)
    end
  end

  context "apply_favorites" do
    it "applies favorites" do
      existing_notice = Fabricate.create(:notice, status: :shared, registration: 'HH PS 123')

      notice.apply_favorites(['HH PS 123'])

      expect(notice.registration).to eql('HH PS 123')
      expect(notice.brand).to eql(existing_notice.brand)
      expect(notice.color).to eql(existing_notice.color)
      expect(notice.charge).to eql(existing_notice.charge)
    end
  end

  context "apply_dates" do
    it "applies dates" do
      date = 60.minutes.ago
      notice.apply_dates([date])

      expect(notice.date).to eql(date)
      expect(notice.duration).to eql(1)

      notice.apply_dates([date, date.advance(minutes: 3)])
      expect(notice.date).to eql(date)
      expect(notice.duration).to eql(3)

      notice.apply_dates([date, date.advance(minutes: 45)])
      expect(notice.date).to eql(date)
      expect(notice.duration).to eql(45)

      notice.apply_dates([date, date.advance(minutes: 60)])
      expect(notice.date).to eql(date)
      expect(notice.duration).to eql(60)

      notice.apply_dates([date, date.advance(minutes: 180)])
      expect(notice.date).to eql(date)
      expect(notice.duration).to eql(180)
    end
  end

  context "incomplete" do
    it "is incomplete" do
      expect(notice).to be_complete
      notice.charge = nil
      expect(notice).to be_invalid
      notice.save_incomplete!
      expect(notice.reload).to be_incomplete
    end
  end

  context "defaults" do
    it "is valid" do
      notice = Fabricate(:notice)
      expect(notice).to be_open
      expect(notice.token).to be_present
    end
  end

  context "scopes" do
    it "finds_for_reminder" do
      notice = Fabricate(:notice, date: 15.days.ago)
      expect(Notice.for_reminder.to_a).to eql([notice])
      notice.user.update! disable_reminders: true
      expect(Notice.for_reminder).to be_empty
    end
  end
end
